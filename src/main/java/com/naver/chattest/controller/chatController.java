package com.naver.chattest.controller;

import java.io.File;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.naver.chattest.EchoHandler2;
import com.naver.chattest.domain.Cart;
import com.naver.chattest.domain.Chat;
import com.naver.chattest.service.MemberService;

@Controller
public class chatController {
	private static final Logger logger = LoggerFactory.getLogger(chatController.class);
	@Autowired
	private MemberService memberservice;

	@Value("${savefoldername}")
	private String saveFolder;
	
	@ResponseBody
	@RequestMapping(value="/idcheck.net")
	public int idcheck(String id) {
		int result = memberservice.isId(id);
		System.out.println(result);
		return result;
	}
	@RequestMapping(value = "/loginForm", method = RequestMethod.GET)
	public String loginform() {
		return "_1/loginForm";
	}

	@RequestMapping(value = "/login_ok", method = RequestMethod.POST)
	public String login_ok(Model m, String name) {
		m.addAttribute("name", name);
		return "_1/websocket_test1";

	}

	@RequestMapping(value = "/login.net")
	public String login() {
		return "_2/loginForm";
	}
	@RequestMapping(value = "/chat.net")
	public String chat() {
		return "_2/boot_sample";
	}
	@RequestMapping(value = "/logout.net")
	public String logout(HttpSession session) {
		session.invalidate();
		return "_2/loginForm";
	}
	//loginProcess를 get방식으로 접근하면 다시 로그인 하도록 페이지를 이동한다.
	@GetMapping(value = "/loginProcess.net")
	public String login2() {
		logger.info("login2()");
		return "redirect:login";
	}
	@GetMapping(value = "/joinProcess")
	public String login3() {
		logger.info("login3()");
		return "redirect:login";
	}
	
	@RequestMapping(value = "/loginProcess.net", method = RequestMethod.POST)
	public ModelAndView loginProcess(@RequestParam("id") String id, @RequestParam("password") String password,
								ModelAndView mv, HttpServletRequest request,	HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> map = memberservice.isMember(id, password);
		int result = Integer.parseInt(map.get("result").toString());
		
		
		if(result == 1) {
			for(Cart cart : EchoHandler2.sessionList) {
				if(cart.getId().equals(id)) {
					response.setContentType("text/html;charset=utf-8");
					response.getWriter()
					.print("<script>alert('이미 소켓 연결중');history.back();</script>");
					return null;
				}
			}
			session.setAttribute("id", id);
			mv.setViewName("_2/boot_sample");
			mv.addObject("name", id);
			mv.addObject("filename", map.get("filename").toString());
			return mv;
		} else {
			String message = "비밀번호가 일치하지 않습니다.";
			if (result == -1) {
				message = "아이디가 존재하지 않습니다.";
			}
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + message + "');");
			out.println("location.href='login.net';");
			out.println("</script>");
			out.close();
			return null;
		}
	}
	@RequestMapping(value = "/join")
	public String join2() {
		return "_2/join";
	}

	@RequestMapping(value = "/joinProcess")
	public String joinProcess(Chat member, HttpServletResponse response) throws Exception {

		MultipartFile uploadfile = member.getUploadfile();
		if (!uploadfile.isEmpty()) {
			String fileName = uploadfile.getOriginalFilename();
			member.setOriginalfile(fileName);

			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR); // 년
			int month = c.get(Calendar.MONTH); // 월
			int date = c.get(Calendar.DATE); // 일

			String homedir = saveFolder + year + "-" + month + "-" + date;
			System.out.println(homedir);
			File path1 = new File(homedir);
			if (!(path1.exists())) {
				path1.mkdir();
			}

			Random r = new Random();
			int random = r.nextInt(100000000);

			int index = fileName.lastIndexOf(".");

			String fileExtension = fileName.substring(index + 1);

			String refileName = "bbs" + year + month + date + random + "." + fileExtension;
			System.out.println("refileName = " + refileName);
			String fileDBName = "/" + year + "-" + month + "-" + date + "/" + refileName;
			System.out.println("fileDBName = " + fileDBName);
			uploadfile.transferTo(new File(saveFolder + fileDBName));
			member.setSavefile(fileDBName);
		}
		int result = memberservice.insert(member);
		System.out.println("가입결과 = " + result);
		
		return "_2/loginForm";
		
	}

}
