package zm.service.course;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import zm.service.oss.OssClient;

@Service
public class Courses {

    @Autowired
    private OssClient oss;

    public Courses(){
    }

    public Course getCourse(String name){
        String content = this.oss.getCourseContent(name);
        Course course  = new Course();
        course.setName( content);

        return course;
    }
}
