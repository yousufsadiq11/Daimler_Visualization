<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="bean.cries"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="name" content="Concept Map" />
<meta name="description"
	content="An abstract mapping for parameters. Works best if first tag is 'unique' among the tracklist, and the second tag applies to multiple tracks" />
<meta name="mintags" content="2" />
<meta name="maxtags" content="2" />
<title>Daimler Truck Dashboard</title>
<style>
#chartContainer {
	height: 30px;
	width: 500px;
}

#chart1 {
	width: 20px;
}

svg {
	font: 12px sans-serif;
}

svg1 {
	font: 12px sans-serif;
}

text {
	pointer-events: none;
}

.inner_node rect {
	pointer-events: all;
}

.inner_node rect.highlight {
	stroke: #315B7E;
	stroke-width: 2px;
}

.outer_node circle {
	fill: #fff;
	stroke: steelblue;
	stroke-width: 1.5px;
	pointer-events: all;
}

.outer_node circle.highlight {
	stroke: #315B7E;
	stroke-width: 2px;
}

.link {
	fill: none;
}
</style>
</head>
<body onload="GetArraylist()">
	<script src="https://d3js.org/d3.v3.min.js"></script>
	<script src="JS/d3.min.js"></script>
	<script src="http://dimplejs.org/dist/dimple.v2.3.0.min.js"></script>
	<%@include file="Visualizations/Network_graph_shortage_items.jsp"%>
	<%@include file="Visualizations/Cries_Summary.jsp"%>
	<div id="chartContainer">
		<script src="JS/d3.min.js"></script>
		<script src="http://dimplejs.org/dist/dimple.v2.3.0.min.js"></script>
		<script src="Visualizations/Paint_Summary.js" type='text/javascript'></script>
		<div class="pull-right">
			<h3>Daimler Truck Dashboard</h3>
		</div>
		<div class="clearfix"></div>
	</div>
</body>
</html>