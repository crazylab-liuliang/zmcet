package zm.service.course;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.OSSObject;
import com.google.gson.Gson;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class Courses {
    private String endPoint = "oss-cn-shenzhen.aliyuncs.com"; //"oss-cn-shenzhen-internal.aliyuncs.com";
    private String bucketName = "alab-web";
    private String coursesLocation = "zm/courses/";
    private String accessKeyId = "LTAIU61mKyyd1kQj";
    private String accessKeySecret = "XmZnUm0dCOUYZSqVDVrWUg6mpMzL9l";


    public Courses(){
    }


    public Course getCourse(String name){
        Course course  = new Course();
        course.setName( name);

        return course;
    }

    /***
     * 获取单元描述信息
     * @param courseName
     * @return
     */
    public CourseMeta getCourseMeta(String courseName){
        // 获取课程配置文件
        OSSClient oss = new OSSClient( endPoint, accessKeyId, accessKeySecret);
        OSSObject ossObj = oss.getObject( bucketName, coursesLocation + courseName + "/course.json");
        ossObj.getObjectContent();

        Gson gson = new Gson();
        CourseMeta courseMeta = new CourseMeta();
        courseMeta = gson.fromJson("", CourseMeta.class);

        return courseMeta;
    }
}
