package doll.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping(value="/", method = RequestMethod.GET)
public class CatchDollController {

    @RequestMapping(value="/catch", method = RequestMethod.GET)
    public String catchDoll(ModelMap model){
        model.addAttribute("msg", "Spring MVC hellow" );
        model.addAttribute("name", "wocao");
        return "CatchDoll";
    }

    @RequestMapping(value="/op", method = RequestMethod.GET)
    public @ResponseBody String onOperationAjax(@RequestParam("type") String type,
                                                @RequestParam("value") String value){

        RestTemplate rest= new RestTemplate();
        rest.getForObject( "http://118.190.156.61:8900/op?machine=apple&type=" + type + "&value=" + value, String.class);
        //rest.getForObject( "http://localhost:8900/op?machine=apple&type=" + type + "&value=" + value, String.class);

        String response = "";
        return response;
    }
}
