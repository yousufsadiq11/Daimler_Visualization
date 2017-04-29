
    var svg = dimple.newSvg("#chartContainer", 1580, 400);
    d3.tsv("input_files/test_paint.tsv", function (data) {
      var myChart = new dimple.chart(svg, data);
      myChart.setBounds(900, 50, 600, 300)
      var x = myChart.addCategoryAxis("x", "vehicle_no");
    x.addOrderRule("vehicle_no");
      myChart.addCategoryAxis("y", "day");
      var s = myChart.addSeries("day", dimple.plot.bubble);
     // s.stacked =true;
      myChart.addLegend(1000, 30, 510, 20, "right");
      myChart.draw();
    });
    
  