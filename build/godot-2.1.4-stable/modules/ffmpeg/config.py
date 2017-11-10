
def can_build(platform):
    return True


def configure(env):
    if env['platform'] == "windows":
        env.Append(CPPPATH=['#modules/ffmpeg/sdk/include'])
        env.Append(LIBPATH=['#modules/ffmpeg/sdk/lib/win32'])
        env.Append(LINKFLAGS=['avformat.lib', 'avcodec.lib', 'avutil.lib', 'swscale.lib'])        
    elif env['platform'] == "osx":
        env.Append(CPPPATH=['/usr/local/include'])
        env.Append(LIBPATH=['/usr/local/lib'])
        env.Append(LINKFLAGS=['-lavformat', '-lavcodec', '-lavutil', '-lswscale'])