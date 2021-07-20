package com.onepage.myapp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.onepage.myapp.video.VideoService;
import com.onepage.myapp.video.VideoVO;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	VideoService videoService;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
//			@RequestParam (required = false, defaultValue = "2") int playlistID
//			) throws Exception {
//		
//		//System.out.println(playlistID);
//		//System.out.println(playlistID.getClass().getName());
//		model.addAttribute("list", videoService.getVideoList(playlistID));
		
		return "home";
	}
	
	@RequestMapping(value = "/addok", method = RequestMethod.POST)
	public String addPostOK(
			@ModelAttribute VideoVO vo) {
		
		if(videoService.insertVideo(vo) == 0) 
			System.out.println("데이터 추가 실패 ");
		else 
			System.out.println("데이터 추가 성공!! ");
		return "home";
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	public String list(Model model,
			@RequestParam (required = false) int playlistID
			) throws Exception {
		
		//System.out.println(playlistID);
		//System.out.println(playlistID.getClass().getName());
		
		model.addAttribute("list", videoService.getVideoList(playlistID));
		
		return "home";
	}
	
}
