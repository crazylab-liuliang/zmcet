package zm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping(value="/zm", method = RequestMethod.GET)
public class ZMController {

    @RequestMapping(value="/course", method = RequestMethod.GET)
    public String catchDoll(ModelMap model){
        model.addAttribute("message", "Hello Sprive MVC, I'm model");

        return "zm/course";
    }
}
