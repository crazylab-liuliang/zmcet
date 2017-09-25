package manager.player;

import java.util.ArrayList;
import java.util.Collection;
import com.google.gson.Gson;
import io.netty.channel.ChannelHandlerContext;

class Cell{
	public int		cell_idx;
	public int		item_id;
	public int		item_num;
	
	Cell(){
		cell_idx = 0;
		item_id = 0;
		item_num = 0;
	}
	
	Cell(int idx, int id, int num){
		cell_idx = idx;
		item_id = id;
		item_num = num;
	}
}

public class Backpack {
	public int 				  cell_number=15;
	public ArrayList<Cell> 	  cells = new ArrayList<Cell>();
	
	public Backpack() {
	}
	
	public Cell AddItem(int item_id, int count, int type){
		Cell cell = getCellByItemID(item_id);
		if( cell!=null){
			cell.item_num += count;
		}else
		{
			int fristCellEmpty = getFirstEmptyCell();
			if( fristCellEmpty!=-1) {
				cell = new Cell(fristCellEmpty, item_id, count);
				cells.add(cell);
			}
		}
		
		return cell;
	}
	
	public Cell getCellByItemID(int id) {
		for(Cell cell : cells) {
			if(cell.item_id == id) {
				return cell;
			}
		}
		
		return null;
	}
	
	public Cell getCellByItemIdx(int idx) {
		for(Cell cell : cells) {
			if(cell.cell_idx == idx) {
				return cell;
			}
		}
		
		return null;
	}
	
	public int getFirstEmptyCell() {
		int cellIdx = -1;
		for(int i=0; i<cell_number; i++) {
			if(isCellEmpty(i)) {
				cellIdx = i;
				break;
			}
		}
		
		return cellIdx;
	}
	
	public boolean isCellEmpty(int idx) {
		for(Cell cell : cells) {
			if(cell.cell_idx == idx) {
				return false;
			}
		}
		
		return true;
	}
}
