package zm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import zm.service.course.Course;
import zm.service.course.Courses;

@Controller
@RequestMapping(value="/zm", method = RequestMethod.GET)
public class ZMController {

    private Courses courses;

    @Autowired
    public ZMController(Courses courses){
        this.courses = courses;
    }

    @RequestMapping(value="/course", method = RequestMethod.GET)
    public String catchDoll(ModelMap model){
        Course course = new Course();// courses.getCourse("cet4");

        model.addAttribute("course", courses.getCourse("cet4"));

        return "zm/course";
    }
}
