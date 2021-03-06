<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="bean.cries"%>


<div id="chart1">
	<script>
	<%String myarraylist = "";
			Connection con = null;
			Map<String, String> map = new HashMap<String, String>();
			try {

				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection("jdbc:mysql://localhost:3306/daimler?autoReconnect=true&useSSL=false",
						"root", "root");
				PreparedStatement pst = con.prepareStatement(
						"select veh_ser_no,GROUP_CONCAT(short_type_cd SEPARATOR ',') concat from item_short where resolved=? and ts_load like ? group by veh_ser_no;");
				pst.setString(1, "false");
				pst.setString(2, "%2017-03-10%");
				ResultSet rs = pst.executeQuery();

				while (rs.next()) {
					map.put(rs.getString("veh_ser_no"), rs.getString("concat"));
					//System.out.println("loop");
				}
			}

			catch (Exception e) {
				e.printStackTrace();
			}%>
	
			
		function GetArraylist() {
			var mn='as';console.log(mn);var MyList=[];
			<%for (Map.Entry<String, String> entry : map.entrySet()) {

				String key = entry.getKey();

				String values = entry.getValue();

				if (myarraylist.equals("") && !(values.contains(","))) {%>
			var key='<%=key%>';
			var value='<%=values%>';

			MyList.push([ key, [ value ] ]);
	<%} //else {
					//myarraylist =  key;%>
		
	<%}
			//  System.out.println("Key = " + key);

			//System.out.println("Values = " + values );

			// }%>
		var data = MyList;
			console.log(MyList);
			var outer = d3.map();

			var inner = [];
			var links = [];

			var outerId = [ 0 ];

			data.forEach(function(d) {

				if (d == null)
					return;

				i = {
					id : 'i' + inner.length,
					name : d[0],
					related_links : []
				};
				i.related_nodes = [ i.id ];
				inner.push(i);

				if (!Array.isArray(d[1]))
					d[1] = [ d[1] ];

				d[1].forEach(function(d1) {

					o = outer.get(d1);

					if (o == null) {
						o = {
							name : d1,
							id : 'o' + outerId[0],
							related_links : []
						};
						o.related_nodes = [ o.id ];
						outerId[0] = outerId[0] + 1;

						outer.set(d1, o);
					}

					// create the links
					l = {
						id : 'l-' + i.id + '-' + o.id,
						inner : i,
						outer : o
					}
					links.push(l);

					// and the relationships
					i.related_nodes.push(o.id);
					i.related_links.push(l.id);
					o.related_nodes.push(i.id);
					o.related_links.push(l.id);
				});
			});

			data = {
				inner : inner,
				outer : outer.values(),
				links : links
			}

			outer = data.outer;
			data.outer = Array(outer.length);

			var i1 = 0;
			var i2 = outer.length - 1;

			for (var i = 0; i < data.outer.length; ++i) {
				if (i % 2 == 1)
					data.outer[i2--] = outer[i];
				else
					data.outer[i1++] = outer[i];
			}

			console.log(data.outer.reduce(function(a, b) {
				return a + b.related_links.length;
			}, 0) / data.outer.length);

			// from d3 colorbrewer: 
			// This product includes color specifications and designs developed by Cynthia Brewer (http://colorbrewer.org/).
			var colors = [ "#a50026", "#d73027", "#f46d43", "#fdae61",
					"#fee090", "#ffffbf", "#e0f3f8", "#abd9e9", "#74add1",
					"#4575b4", "#313695" ]
			var color = d3.scale.linear().domain([ 60, 220 ]).range(
					[ colors.length - 1, 0 ]).clamp(true);

			var diameter = 900;
			var rect_width = 60;
			var rect_height = 17;

			var link_width = "1.5px";

			var il = data.inner.length;
			var ol = data.outer.length;

			var inner_y = d3.scale.linear().domain([ 0, il ]).range(
					[ -(il * rect_height) / 2, (il * rect_height) / 2 ]);

			mid = (data.outer.length / 2.0)
			var outer_x = d3.scale.linear().domain(
					[ 0, mid, mid, data.outer.length ]).range(
					[ 15, 170, 190, 350 ]);

			var outer_y = d3.scale.linear().domain([ 0, data.outer.length ])
					.range([ 0, diameter / 2 - 120 ]);

			// setup positioning
			data.outer = data.outer.map(function(d, i) {
				d.x = outer_x(i);
				d.y = diameter / 3;
				return d;
			});

			data.inner = data.inner.map(function(d, i) {
				d.x = -(rect_width / 2);
				d.y = inner_y(i);
				return d;
			});

			function get_color(name) {
				console.log(name);
				var c = Math.round(color(name));
				if (isNaN(name)) {
					var lastChar = name.substr(name.length - 1);
					var a = parseInt(lastChar);
					return colors[a];
					// fallback color
				}
				return '#a50026';

			}

			function get_color_outer(name) {
				if (name == 'T')
					return '#c2d6d6';
				if (name == 'B')
					return '#ffd1b3';
				if (name == 'O')
					return '#ffccff';
				if (name == 'E')
					return '#99bbff';
				if (name == 'I')
					return '#66ffd9';
			}

			// Can't just use d3.svg.diagonal because one edge is in normal space, the
			// other edge is in radial space. Since we can't just ask d3 to do projection
			// of a single point, do it ourselves the same way d3 would do it.  

			function projectX(x) {
				return ((x - 90) / 180 * Math.PI) - (Math.PI / 2);
			}

			var diagonal = d3.svg.diagonal().source(function(d) {
				return {
					"x" : d.outer.y * Math.cos(projectX(d.outer.x)),
					"y" : -d.outer.y * Math.sin(projectX(d.outer.x))
				};
			}).target(function(d) {
				return {
					"x" : d.inner.y + rect_height / 2,
					"y" : d.outer.x > 180 ? d.inner.x : d.inner.x + rect_width
				};
			}).projection(function(d) {
				return [ d.y, d.x ];
			});

			var svg = d3.select("body").append("svg").attr("width", diameter)
					.attr("height", diameter).append("g").attr(
							"transform",
							"translate(" + diameter / 2 + "," + diameter / 2
									+ ")");

			// links
			var link = svg.append('g').attr('class', 'links')
					.selectAll(".link").data(data.links).enter().append('path')
					.attr('class', 'link').attr('id', function(d) {
						return d.id
					}).attr("d", diagonal).attr('stroke', function(d) {
						return get_color_outer(d.outer.name);
					}).attr('stroke-width', link_width);

			// outer nodes

			var onode = svg.append('g').selectAll(".outer_node").data(
					data.outer).enter().append("g").attr("class", "outer_node")
					.attr(
							"transform",
							function(d) {
								return "rotate(" + (d.x - 90) + ")translate("
										+ d.y + ")";
							}).on("mouseover", mouseover_outer).on("mouseout",
							mouseout_outer);

			onode.append("circle").attr('id', function(d) {
				return d.id
			}).attr("r", 4.5);

			onode.append("circle").attr('r', 20).attr('visibility', 'hidden');

			onode.append("text").attr('id', function(d) {
				return d.id + '-txt';
			}).attr("dy", ".31em").attr("text-anchor", function(d) {
				return d.x < 180 ? "start" : "end";
			}).attr("transform", function(d) {
				return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)";
			}).text(function(d) {
				return d.name;
			});

			// inner nodes

			var inode = svg.append('g').selectAll(".inner_node").data(
					data.links).enter().append("g").attr("class", "inner_node")
					.attr("transform", function(d, i) {
						return "translate(" + d.inner.x + "," + d.inner.y + ")"
					}).on("mouseover", mouseover).on("mouseout", mouseout);

			inode.append('rect').attr('width', rect_width).attr('height',
					rect_height).attr('id', function(d) {
				return d.inner.id;
			}).attr('fill', function(d) {
				return get_color_outer(d.outer.name);
			});

			inode.append("text").attr('id', function(d) {
				return d.inner.id + '-txt';
			}).attr('text-anchor', 'middle').attr(
					"transform",
					"translate(" + rect_width / 2 + ", " + rect_height * .75
							+ ")").text(function(d) {
				return d.inner.name;
			});

			// need to specify x/y/etc

			d3.select(self.frameElement).style("height", diameter - 150 + "px");

			function mouseover(d) {
				// bring to front
				d3.selectAll('.links .link').sort(function(a, b) {
					return d.inner.related_links.indexOf(a.id);
				});

				for (var i = 0; i < d.inner.related_nodes.length; i++) {
					d3.select('#' + d.inner.related_nodes[i]).classed(
							'highlight', true);
					d3.select('#' + d.inner.related_nodes[i] + '-txt').attr(
							"font-weight", 'bold');
				}

				for (var i = 0; i < d.inner.related_links.length; i++)
					d3.select('#' + d.inner.related_links[i]).attr(
							'stroke-width', '5px');
			}

			function mouseout(d) {
				for (var i = 0; i < d.inner.related_nodes.length; i++) {
					d3.select('#' + d.inner.related_nodes[i]).classed(
							'highlight', false);
					d3.select('#' + d.inner.related_nodes[i] + '-txt').attr(
							"font-weight", 'normal');
				}

				for (var i = 0; i < d.inner.related_links.length; i++)
					d3.select('#' + d.inner.related_links[i]).attr(
							'stroke-width', link_width);
			}

			function mouseover_outer(d) {
				// bring to front
				d3.selectAll('.links .link').sort(function(a, b) {
					return d.related_links.indexOf(a.id);
				});

				for (var i = 0; i < d.related_nodes.length; i++) {
					d3.select('#' + d.related_nodes[i]).classed('highlight',
							true);
					d3.select('#' + d.related_nodes[i] + '-txt').attr(
							"font-weight", 'bold');
				}

				for (var i = 0; i < d.related_links.length; i++)
					d3.select('#' + d.related_links[i]).attr('stroke-width',
							'5px');
			}

			function mouseout_outer(d) {
				for (var i = 0; i < d.related_nodes.length; i++) {
					d3.select('#' + d.related_nodes[i]).classed('highlight',
							false);
					d3.select('#' + d.related_nodes[i] + '-txt').attr(
							"font-weight", 'normal');
				}

				for (var i = 0; i < d.related_links.length; i++)
					d3.select('#' + d.related_links[i]).attr('stroke-width',
							link_width);
			}
			GetArraylist1();
		}
		//var z=MyList.split(',');
	</script>
	</div>