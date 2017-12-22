package zm.beans.course;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class Courses {

    private List<Course> courseList;

    public Courses(){
    }

    public Course getCourse(String name){
        return courseList.get(0);
    }

    public String test(){
        return "+++++++++++++++++++++++++";
    }
}
