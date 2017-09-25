package net.socket;

import io.netty.channel.ChannelHandlerContext;
import manager.player.Player;
import manager.ranking.RankingMgr;

interface ProtocolProcess {
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx);
	
	public static void bind() {
		SocketServerHandler.bind(new protocol.register_by_email(), new register_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_email(), new login_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_osid(), new login_by_osid_process());
		SocketServerHandler.bind(new protocol.heart_beat(), new heart_beat_process());
		SocketServerHandler.bind(new protocol.ranking_request(), new ranking_request_process());
	}
}

class register_by_email_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.register_by_email msg = (protocol.register_by_email)proto;
		
		Player player = Player.get(ctx);
		player.registerByEmail( msg.email, msg.password);
	}
}

class login_by_email_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.login_by_email msg = (protocol.login_by_email)proto;	
		
		Player player = Player.get(ctx);
		player.loginByEmail(msg.email, msg.password);
	}
}

class login_by_osid_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.login_by_osid msg = (protocol.login_by_osid)proto;	
		
		Player player = Player.get(ctx);
		player.loginByOSID(msg.osid);
	}
}

class heart_beat_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		protocol.heart_beat msg = (protocol.heart_beat)proto;	
		Player player = Player.get(ctx);
		player.on_heart_beat(msg.data());
	}
}

class ranking_request_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {		
		RankingMgr.getInstance().onRequestRanking(ctx);
	}
}