package zm.service.course;

import java.util.ArrayList;
import java.util.List;

public class CourseMeta {
    private String  rootURL;
    private String  name;
    private String  icon;
    private List<UnitMeta> unitMetas = new ArrayList<UnitMeta>();

    public void setURL(String url){
        this.rootURL = url;
    }

    public String getURL(){
        return this.rootURL;
    }

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    public String getIcon(){
        return icon;
    }

    public void setIcon(String icon){
        this.icon = icon;
    }

    public List<UnitMeta> getUnitMetas(){
        return unitMetas;
    }

    public void addUnitMeta( UnitMeta um){
        this.unitMetas.add(um);
    }
}
