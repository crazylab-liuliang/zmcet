package quartz;

import java.text.ParseException;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import App.app;

public class JobMgr {
	private static JobMgr inst = null;
	
	private JobMgr() {
		
	}
	
	public static JobMgr getInstance() {
		if(inst==null) {
			inst = new JobMgr();
		}
		
		return inst;
	}
	
	// ��ʼ����������
	public void startJobs() {
		// ���ݱ����ʱ��
		Timer dbSaveTimer = new Timer();
		//dbSaveTimer.scheduleAtFixedRate(new TimerTask() {
		//	@Override
		//	public void run() {
		//		manager.player.Player.updateAll();
		//	}
		//}, 5*1000, 5*1000);
		
		// ս�����¼�ʱ��
		//Timer roomUpdateTimer = new Timer();
		//roomUpdateTimer.scheduleAtFixedRate(new TimerTask() {
		//	@Override
		//	public void run() {
		//		manager.room.RoomMgr.update();
		//	}
		//}, 0, 1000);
		
		// ���ݱ����ʱ��
		//Timer rdSaveTimer = new Timer();
		//rdSaveTimer.scheduleAtFixedRate(new TimerTask() {
		//	@Override
		//	public void run() {
		//		manager.ranking.RankingMgr.getInstance().saveToDB();
		//	}
		//}, 300*1000, 300*1000);
	}
}
