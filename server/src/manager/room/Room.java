package manager.room;

import io.netty.buffer.ByteBuf;
import manager.player.Player;

enum GameState{
	GS_PREPARE,
	GS_PLAYER_READY,
	GS_PLAYER0_TURN,
	GS_PLAYER1_TURN,
	GS_END
}

public class Room {
	protected static  Integer m_roomCreated = 0;
	protected Integer m_id;
	public GameState  m_gameState = GameState.GS_PREPARE;
	public float  	  m_battleTime= 0.f;
	public float	  m_turnTime = 30.f;
	public Long 	  m_player0 = null;
	public Long 	  m_player1 = null;
	protected int	  m_player0Blood = 100;
	protected int	  m_player1Blood = 100;
	
	public Room(){
		m_id = m_roomCreated++;
	}
	
	public Integer getID() {
		return m_id;
	}
	
	public void process(float delta){
		m_battleTime += delta;
		if(m_gameState == GameState.GS_PLAYER_READY && m_battleTime>=1.f) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
		}
		else if(m_gameState==GameState.GS_PLAYER0_TURN) {
			m_turnTime -= delta;
			if(m_turnTime < 0.f) {
				on_batle_switch_turn(m_player0);
			}
		}
		else if(m_gameState==GameState.GS_PLAYER1_TURN) {
			m_turnTime -= delta;
			if(m_turnTime < 0.f) {
				on_batle_switch_turn(m_player1);
			}
		}
		else if(m_gameState==GameState.GS_END) {
			
		}
		
		sendBattleTime();
	}
	
	void addPlayer( Long p0, Long p1) {
		m_player0 = p0;
		m_player1 = p1;
		
		m_gameState = GameState.GS_PLAYER_READY;
	}
	
	void sendBattleTime() {
	}
	
	void sendBattleTurnBegin(GameState state) {
	}
	
	public void on_batle_switch_turn(Long player) {
		if(player==m_player0 && m_gameState==GameState.GS_PLAYER0_TURN) {
			m_gameState = GameState.GS_PLAYER1_TURN;
			m_turnTime = 30.f;
			sendBattleTurnBegin(GameState.GS_PLAYER1_TURN);
		}
		else if (player==m_player1 && m_gameState==GameState.GS_PLAYER1_TURN) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			m_turnTime = 30.f;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
		}
	}
	
	protected void sendMsgToPlayer( Long playerID, ByteBuf buf) {
		Player player = Player.getById( playerID);
		if(player!=null) {
			player.sendMsg(buf);
		}
		else {
			Player player0 = Player.getById(m_player0);
			Player player1 = Player.getById(m_player1);
			if(player0==null && player1==null) {
				RoomMgr.instance().close_room(getID(), m_player0, m_player1);
			}
		}
	}
}
