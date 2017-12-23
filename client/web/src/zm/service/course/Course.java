package zm.service.course;

import org.springframework.stereotype.Component;

public class Course {
    private String name;

    public String getName(){
        return this.name;
    }

    public void setName(String name){
        this.name = name;
    }

}
