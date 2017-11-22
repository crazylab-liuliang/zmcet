/*************************************************************************/
/*  video_stream_theora.cpp                                              */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                      https://godotengine.org                          */
/*************************************************************************/
/* Copyright (c) 2007-2017 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2017 Godot Engine contributors (cf. AUTHORS.md)    */
/*                                                                       */
/* Permission is hereby granted, free of charge, to any person obtaining */
/* a copy of this software and associated documentation files (the       */
/* "Software"), to deal in the Software without restriction, including   */
/* without limitation the rights to use, copy, modify, merge, publish,   */
/* distribute, sublicense, and/or sell copies of the Software, and to    */
/* permit persons to whom the Software is furnished to do so, subject to */
/* the following conditions:                                             */
/*                                                                       */
/* The above copyright notice and this permission notice shall be        */
/* included in all copies or substantial portions of the Software.       */
/*                                                                       */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
/*************************************************************************/
#include "video_stream_ffmpeg.h"

#include "globals.h"
#include "os/os.h"

#include "thirdparty/misc/yuv2rgb.h"

static bool isInited = false;

VideoStreamPlaybackFFMPEG::VideoStreamPlaybackFFMPEG() {
	if(!isInited){
		av_register_all();

		isInited = true;
	}

	m_formatCtx = NULL;
	m_videoStreamIdx = -1;
	m_videoCodec = NULL;
	m_videoCodecCtx = NULL;
	m_videoFrame = NULL;
	m_videoFrameTime = 0.0;

	videobuf_ready = 0;
	playing = false;
	frames_pending = 0;
	videobuf_time = 0;
	paused = false;

	buffering = false;
	m_videoTexture = Ref<ImageTexture>(memnew(ImageTexture));
	mix_callback = NULL;
	mix_udata = NULL;
	audio_track = 0;
	delay_compensation = 0;
	audio_frames_wrote = 0;

#ifdef THEORA_USE_THREAD_STREAMING
	int rb_power = nearest_shift(RB_SIZE_KB * 1024);
	ring_buffer.resize(rb_power);
	read_buffer.resize(RB_SIZE_KB * 1024);
	thread_sem = Semaphore::create();
	thread = NULL;
	thread_exit = false;
	thread_eof = false;

#endif
};

VideoStreamPlaybackFFMPEG::~VideoStreamPlaybackFFMPEG() {

#ifdef THEORA_USE_THREAD_STREAMING

	memdelete(thread_sem);
#endif
	clear();
};

void VideoStreamPlaybackFFMPEG::write_frame_to_texture(void) {

	int pitch = 4;
	frame_data.resize(m_videoWidth * m_videoHeight * pitch);
	{
		DVector<uint8_t>::Write w = frame_data.write();
		char *dst = (char *)w.ptr();

		AVPixelFormat px_fmt = AVPixelFormat(m_videoFrame->format);

		if (px_fmt == AV_PIX_FMT_YUV444P) {

			yuv444_2_rgb8888((uint8_t *)dst, (uint8_t *)m_videoFrame->data[0], (uint8_t *)m_videoFrame->data[1], (uint8_t *)m_videoFrame->data[2], m_videoWidth, m_videoHeight, m_videoFrame->linesize[0], m_videoFrame->linesize[1], m_videoWidth << 2, 0);

		} else if (px_fmt == AV_PIX_FMT_YUV422P) {

			yuv422_2_rgb8888((uint8_t *)dst, (uint8_t *)m_videoFrame->data[0], (uint8_t *)m_videoFrame->data[1], (uint8_t *)m_videoFrame->data[2], m_videoWidth, m_videoHeight, m_videoFrame->linesize[0], m_videoFrame->linesize[1], m_videoWidth << 2, 0);

		} else if (px_fmt == AV_PIX_FMT_YUV420P) {

			yuv420_2_rgb8888((uint8_t *)dst, (uint8_t *)m_videoFrame->data[0], (uint8_t *)m_videoFrame->data[2], (uint8_t *)m_videoFrame->data[1], m_videoWidth, m_videoHeight, m_videoFrame->linesize[0], m_videoFrame->linesize[1], m_videoWidth << 2, 0);
		};

		m_videoTextureFormat = Image::FORMAT_RGBA;
	}

	Image img(m_videoWidth, m_videoHeight, 0, m_videoTextureFormat, frame_data); //zero copy image creation

	m_videoTexture->set_data(img); //zero copy send to visual server

	frames_pending = 1;
}

void VideoStreamPlaybackFFMPEG::clear() {
	//av_packet_unref(&m_packet);
	av_frame_free(&m_videoFrame);
	avcodec_free_context(&m_videoCodecCtx);
	avcodec_close(m_videoCodecCtx);
	avformat_close_input(&m_formatCtx);


#ifdef THEORA_USE_THREAD_STREAMING
	thread_exit = true;
	thread_sem->post(); //just in case
	Thread::wait_to_finish(thread);
	memdelete(thread);
	thread = NULL;
	ring_buffer.clear();
#endif
	videobuf_ready = 0;
	frames_pending = 0;
	videobuf_time = 0;

	playing = false;
};

void VideoStreamPlaybackFFMPEG::set_file(const String &p_file) {
	
	m_fileName = p_file;

	const char* fileName = "E:/test.mp4";

	// open video file
	if (avformat_open_input(&m_formatCtx, fileName, NULL, NULL) != 0) {
		fprintf(stderr, "avformat_open_input failed\n");
		return;
	}

	// retrieve stream information
	if (avformat_find_stream_info(m_formatCtx, NULL) < 0) {
		fprintf(stderr, "avformat_find_stream_info failed\n");
		return;
	}

	// Dump information about file onto standard error
	//av_dump_format(m_formatCtx, 0, "E:/test.mp4", 0);

	// find the first video stream idx
	m_videoStreamIdx = -1;
	for (int i = 0; i < m_formatCtx->nb_streams; i++)
	{
		AVCodecParameters* par = m_formatCtx->streams[i]->codecpar;
		if ( par && par->codec_type == AVMEDIA_TYPE_VIDEO) 
		{
			m_videoStreamIdx = i;
			break;
		}
	}

	if (m_videoStreamIdx == -1) {
		fprintf(stderr, "can't find video stream in the video file\n");
		return;
	}


	m_videoCodecpar = m_formatCtx->streams[m_videoStreamIdx]->codecpar;

	m_videoCodec = avcodec_find_decoder(m_videoCodecpar->codec_id);
	if (m_videoCodec == NULL) {
		fprintf(stderr, "avcodec_find_decoder failed");
		return;
	}

	// create codec context
	m_videoCodecCtx = avcodec_alloc_context3(m_videoCodec);
	avcodec_parameters_to_context(m_videoCodecCtx, m_videoCodecpar);

	// open codec
	if (avcodec_open2(m_videoCodecCtx, m_videoCodec, NULL) < 0) {
		fprintf(stderr, "avcodec_open2 failed\n");
		return;
	}


	m_videoWidth = m_videoCodecpar->width;
	m_videoHeight = m_videoCodecpar->height;
	m_videoTexture->create(m_videoWidth, m_videoHeight, Image::FORMAT_RGBA, Texture::FLAG_FILTER | Texture::FLAG_VIDEO_SURFACE);

	m_videoFrame = av_frame_alloc();
	m_videoFrameTime = 0.0;

	playing = false;
};

float VideoStreamPlaybackFFMPEG::get_time() const {

	//print_line("total: "+itos(get_total())+" todo: "+itos(get_todo()));
	//return MAX(0,time-((get_total())/(float)vi.rate));
	return m_time - AudioServer::get_singleton()->get_output_delay() - delay_compensation; //-((get_total())/(float)vi.rate);
};

Ref<Texture> VideoStreamPlaybackFFMPEG::get_texture() {

	return m_videoTexture;
}

void VideoStreamPlaybackFFMPEG::update(float p_delta) 
{
	//fprintf(stderr, p_delta);

	if (!playing || paused) {
		return;
	};

	m_time += p_delta;
	if (m_time > m_videoFrameTime)
	{
		bool decoderSucceed = false;
		while (!decoderSucceed)
		{
			if (av_read_frame(m_formatCtx, &m_packet) >= 0) {
				if (m_packet.stream_index == m_videoStreamIdx) {
					decode_frame_from_packet(m_videoCodecCtx, m_videoFrame, &m_packet);
					decoderSucceed = true;
				}
			}
		}
	}
};

void VideoStreamPlaybackFFMPEG::decode_frame_from_packet(AVCodecContext *dec_ctx, AVFrame *frame, AVPacket *pkt){
	
	int ret = avcodec_send_packet(dec_ctx, pkt);
	if (ret < 0) {
		fprintf(stderr, "Error sending a packet for decoding\n");
		return;
	}

	while (ret >= 0) {
		ret = avcodec_receive_frame(dec_ctx, frame);
		if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
			return;
		else if (ret < 0) {
			fprintf(stderr, "Error during decoding\n");
			return;
		}

		write_frame_to_texture();

		m_videoFrameTime = 0.0;
		if(pkt->dts != AV_NOPTS_VALUE){
			m_videoFrameTime = av_frame_get_best_effort_timestamp(frame);
		}
		else {
			m_videoFrameTime = 0.0;
		}

		AVRational frameRate = dec_ctx->time_base;//av_inv_q(dec_ctx->framerate);
		m_videoFrameTime = m_videoFrameTime * av_q2d(frameRate) * 0.001f;
	}
}

void VideoStreamPlaybackFFMPEG::play() {

	if (!playing)
		m_time = 0;
	else {
		stop();
	}

	playing = true;
	delay_compensation = Globals::get_singleton()->get("audio/video_delay_compensation_ms");
	delay_compensation /= 1000.0;
};

void VideoStreamPlaybackFFMPEG::stop() {

	if (playing) {

		clear();
		set_file(m_fileName); //reset
	}
	playing = false;
	m_time = 0;
	m_videoFrameTime = 0.0;
};

bool VideoStreamPlaybackFFMPEG::is_playing() const {

	return playing;
};

void VideoStreamPlaybackFFMPEG::set_paused(bool p_paused) {

	paused = p_paused;
	//pau = !p_paused;
};

bool VideoStreamPlaybackFFMPEG::is_paused(bool p_paused) const {

	return paused;
};

void VideoStreamPlaybackFFMPEG::set_loop(bool p_enable){

};

bool VideoStreamPlaybackFFMPEG::has_loop() const {

	return false;
};

float VideoStreamPlaybackFFMPEG::get_length() const {

	return 0;
};

String VideoStreamPlaybackFFMPEG::get_stream_name() const {

	return "";
};

int VideoStreamPlaybackFFMPEG::get_loop_count() const {

	return 0;
};

float VideoStreamPlaybackFFMPEG::get_pos() const {

	return get_time();
};

void VideoStreamPlaybackFFMPEG::seek_pos(float p_time){

	// no
};

void VideoStreamPlaybackFFMPEG::set_mix_callback(AudioMixCallback p_callback, void *p_userdata) {

	mix_callback = p_callback;
	mix_udata = p_userdata;
}

int VideoStreamPlaybackFFMPEG::get_channels() const {

	return 0;
}

void VideoStreamPlaybackFFMPEG::set_audio_track(int p_idx) {

	audio_track = p_idx;
}

int VideoStreamPlaybackFFMPEG::get_mix_rate() const {

	return 0;
}

#ifdef THEORA_USE_THREAD_STREAMING

void VideoStreamPlaybackFFMPEG::_streaming_thread(void *ud) {

	return;
}

#endif


RES ResourceFormatLoaderVideoStreamFFMPEG::load(const String &p_path, const String &p_original_path, Error *r_error) {
	if (r_error)
		*r_error = ERR_FILE_CANT_OPEN;

	VideoStreamFFMPEG *stream = memnew(VideoStreamFFMPEG);
	stream->set_file(p_path);

	if (r_error)
		*r_error = OK;

	return Ref<VideoStreamFFMPEG>(stream);
}

void ResourceFormatLoaderVideoStreamFFMPEG::get_recognized_extensions(List<String> *p_extensions) const {

	p_extensions->push_back("mp4");
}
bool ResourceFormatLoaderVideoStreamFFMPEG::handles_type(const String &p_type) const {
	return (p_type == "VideoStream" || p_type == "VideoStreamFFMPEG");
}

String ResourceFormatLoaderVideoStreamFFMPEG::get_resource_type(const String &p_path) const {

	String exl = p_path.extension().to_lower();
	if (exl == "mp4")
		return "VideoStreamFFMPEG";
	return "";
}
