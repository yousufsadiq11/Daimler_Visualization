import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.google.gson.Gson;


import bean.cries;

public class GsonExample {
	public static void main(String[] args) {

		cries obj = new cries();
		Gson gson = new Gson();
		obj.setLoc("17");
		obj.setVeh_ser_no("VHASA12");
		// obj.setInsp_comt("bid");
		obj.setTs_load("2017-03-06 02:51:34.943000");
		obj.setFound_insp_team("629");
		obj.setResp_insp_team("205");
		obj.setResp_insp_oprunt("200");

		try {
			ArrayList<cries> a=new ArrayList<cries>();
			java.sql.Connection con = null;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(
					"jdbc:mysql://127.0.0.1:3306/daimler?autoReconnect=true&useSSL=false",
					"root", "root");
			PreparedStatement pst = con.prepareStatement("select ts_load as day,resp_insp_oprunt,count(resp_insp_oprunt) as count from cries c join dates d on c.ts_load like concat('%',d.date_of_operation,'%') where resp_insp_oprunt like '%%' and resp_insp_oprunt!='' group by resp_insp_oprunt,d.date_of_operation ");
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
            	cries c=new cries();
            	c.setTs_load(rs.getString("day"));
            	c.setResp_insp_oprunt(rs.getString("resp_insp_oprunt"));
            	c.setCount(rs.getInt("count"));
            	a.add(c);
            }
            for(int i=0;i<a.size();i++){
            	
            
			String json = gson.toJson(a.get(i));
			System.out.println(json);}

			con.close();

		} catch (Exception e) {
			e.printStackTrace();

		}

	}
}


    