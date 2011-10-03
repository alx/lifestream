var w = 960,
    pw = 140,
    z = ~~((w - pw * 2) / 53),
    ph = z >> 1,
    h = (z + 12) * 7;

var vis = d3.select("#chart")
  .selectAll("svg")
    .data(d3.range(2010, 2012))
  .enter().append("svg:svg")
    .attr("width", w)
    .attr("height", h + ph * 2)
    .attr("class", "RdYlGn")
  .append("svg:g")
    .attr("transform", "translate(" + pw + "," + ph + ")");

vis.append("svg:text")
    .attr("transform", "translate(-6," + h / 2 + ")rotate(-90)")
    .attr("text-anchor", "middle")
    .text(function(d) { return d; });

vis.selectAll("rect.day")
    .data(calendar.dates)
  .enter()
    .append("svg:image")
    .attr("x", function(d) { return d.week * z; })
    .attr("y", function(d) { return d.day * (z + 12); })
    .attr("width", z)
    .attr("class", "day")
    .attr("xlink:href", function(d) {
      return "pixel-days-dark/day-" + d.Date + ".jpg";
    })
    .attr("height", 24);
;
vis.selectAll("path.month")
    .data(calendar.months)
  .enter().append("svg:path")
    .attr("class", "month")
    .attr("d", function(d) {
      return "M" + (d.firstWeek + 1) * z + "," + d.firstDay * (z + 12)
          + "H" + d.firstWeek * z
          + "V" + 7 * (z + 12)
          + "H" + d.lastWeek * z
          + "V" + (d.lastDay + 1) * (z + 12)
          + "H" + (d.lastWeek + 1) * z
          + "V" + 0
          + "H" + (d.firstWeek + 1) * z
          + "Z";
    });

