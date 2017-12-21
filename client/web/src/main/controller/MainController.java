package main.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping(value="/", method = RequestMethod.GET)
public class MainController {

    @RequestMapping(value="/", method = RequestMethod.GET)
    public String catchDoll(ModelMap model){
        model.addAttribute("msg", "Spring MVC hellow" );
        model.addAttribute("name", "wocao");
        return "index";
    }
}
