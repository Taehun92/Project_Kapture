package com.example.kapture.board.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.board.dao.BoardService;
import com.google.gson.Gson;

@Controller
public class BoardController {
	
	@Autowired
	BoardService boardService;

	@RequestMapping("/board/list.do")
    public String boardList(Model model) throws Exception{
        return "/board/board-list";
    }
	
	@RequestMapping("/board/add.do")
    public String add(Model model) throws Exception{
        return "/board/board-add";
    }
	
	@RequestMapping("/board/view.do")
    public String view(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		System.out.println(map);
		request.setAttribute("map", map);
        return "/board/board-view";
    }
	
	@RequestMapping("/board/edit.do")
    public String edit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		System.out.println(map);
		request.setAttribute("map", map);
        return "/board/board-edit";
    }
	
	// 게시글 목록 조회
	@RequestMapping(value = "/board/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardList(map);
		return new Gson().toJson(resultMap);
	}
	
	//게시글 추가
	@RequestMapping(value = "/board/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.addBoard(map);
		return new Gson().toJson(resultMap);
	}
	
	//게시글 상세정보 조회
	@RequestMapping(value = "/board/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoard(map);
		return new Gson().toJson(resultMap);
	}
	
	//게시글 수정
		@RequestMapping(value = "/board/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String boardEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			resultMap = boardService.editBoard(map);
			return new Gson().toJson(resultMap);
		}
	
	
}
