package zm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import zm.service.course.Course;
import zm.service.course.Courses;
import zm.service.oss.OssClient;

@Controller
@RequestMapping(value="/zm", method = RequestMethod.GET)
public class ZMController {

    @Autowired
    private Courses courses;

    /***
     * 请求显示所有课程
     * @param model
     * @return 视图名称
     */
    @RequestMapping(value="/courses", method = RequestMethod.GET)
    public String getCourses(ModelMap model){

        model.addAttribute("coursesSummary", courses.getSummary());

        return "zm/courses";
    }

    /***
     * 具体课程页面
     * @param model
     * @return 视图名称
     */
    @RequestMapping(value="/course", method = RequestMethod.GET)
    public String catchDoll(ModelMap model){
        Course course = new Course();// courses.getCourse("cet4");

        model.addAttribute("course", courses.getCourse("cet4"));

        return "zm/course";
    }
}
