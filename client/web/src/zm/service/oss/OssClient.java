package zm.service.oss;

import com.aliyun.oss.model.OSSObjectSummary;
import com.aliyun.oss.model.ObjectListing;
import org.springframework.stereotype.Service;
import com.aliyun.oss.OSSClient;

import java.util.List;

@Service
public class OssClient {

    private String endPoint = "oss-cn-shenzhen.aliyuncs.com";
    private String endPointInternal = "oss-cn-shenzhen-internal.aliyuncs.com";
    private String bucketName = "alab-web";
    private String coursesLocation = "zm/courses/";
    private String accessKeyId = "LTAIU61mKyyd1kQj";
    private String accessKeySecret = "XmZnUm0dCOUYZSqVDVrWUg6mpMzL9l";

    public String getCourseContent(String name){
        return "xxxxxxxxxxxxxxx";
    }

    /**
     * @return 文件信息
     */
    public String getObjectSummaries(){
        OSSClient oss = new OSSClient( endPoint, accessKeyId, accessKeySecret);
        ObjectListing listing = oss.listObjects( bucketName, "");

        String result = "";
        for(OSSObjectSummary summary : listing.getObjectSummaries()){
            result += summary.getKey();
        }

        return result;
    }
}
