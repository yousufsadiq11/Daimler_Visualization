<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="bean.cries"%>
<div id="chartContainer">
		<script src="JS/d3.min.js"></script>
		<script src="http://dimplejs.org/dist/dimple.v2.3.0.min.js"></script>
		<script type="text/javascript">
			
		<%Gson z = new Gson();
			String json;
			ArrayList<cries> a = new ArrayList<cries>();
			try {

				java.sql.Connection conn = null;
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(
						"jdbc:mysql://127.0.0.1:3306/daimler?autoReconnect=true&useSSL=false", "root", "root");
				PreparedStatement pst1 = conn.prepareStatement(
						"select ts_load as day,resp_insp_oprunt,count(resp_insp_oprunt) as count from cries c join dates d on c.ts_load like concat('%',d.date_of_operation,'%') where resp_insp_oprunt like '%%' and resp_insp_oprunt!='' group by resp_insp_oprunt,d.date_of_operation ");
				ResultSet rs1 = pst1.executeQuery();
				while (rs1.next()) {
					cries c = new cries();
					c.setTs_load(rs1.getString("day"));
					c.setResp_insp_oprunt(rs1.getString("resp_insp_oprunt"));
					c.setCount(rs1.getInt("count"));
					a.add(c);
				}

				conn.close();

			} catch (Exception e) {
				e.printStackTrace();

			}%>
			function GetArraylist1() {
				var mn = 'second list';
				console.log(mn);
				var MyList1 = [];
		<%for (int i = 0; i < a.size(); i++) {

				json = z.toJson(a.get(i));
				System.out.println(json);%>
			var temp =
		<%=json%>
			;
				MyList1.push(temp);
		<%}%>
			var svg1 = dimple.newSvg("#chartContainer", 1580, 400);

				// The default data set for these examples has regular times
				// and the point of this demo is to show the time axis
				// functionality, therefore a small bespoke data set is used.
				var data1 = MyList1;
				console.log(data1);
				var qq;
				data1.forEach(function(d) {
					d["Date"] = d["ts_load"];
					d["resp_insp_oprunt"] = d["resp_insp_oprunt"];
					console.log(d["resp_insp_oprunt"]);
				}, this);

				// Create the chart as usual
				var myChart = new dimple.chart(svg1, data1);
				myChart.setBounds(900, 150, 600, 220)
				var x = myChart.addCategoryAxis("x", "Date");
				var y = myChart.addMeasureAxis("y", "resp_insp_oprunt");
				var z = myChart.addMeasureAxis("z", "count");
				x.overrideMin = new Date("2017-03-06");
				x.overrideMax = new Date("2017-03-14");
				y.overrideMin = 0;
				y.overrideMax = 700;
				x.timeInterval = 1;
				z.overrideMin = -10;
				z.overrideMax = 90;
				myChart.addSeries("resp_insp_oprunt", dimple.plot.bubble);
				var s = myChart.addSeries("resp_insp_oprunt", dimple.plot.line);
				s.lineMarkers = true;
				myChart.addLegend(850, 120, 500, 40, "right");
				myChart.draw();
			}
		</script>

	</div>
