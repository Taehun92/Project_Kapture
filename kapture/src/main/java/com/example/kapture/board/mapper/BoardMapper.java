package com.example.kapture.board.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.board.model.Board;

@Mapper
public interface BoardMapper {

	List<Board> selectBoardList(HashMap<String, Object> map);

	void insertBoard(HashMap<String, Object> map);

	Board selectBoard(HashMap<String, Object> map);

	void updateBoard(HashMap<String, Object> map);

}
