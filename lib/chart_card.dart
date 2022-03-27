import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample3 extends StatefulWidget {


  const LineChartSample3({Key? key, required this.dataPassed, required this.xMax, required this.yMax, required this.intervalCheck}) : super(key: key);

  final dynamic dataPassed;
  final dynamic xMax;
  final  dynamic yMax;
  final dynamic intervalCheck;

  @override
  _LineChartSample3State createState() => _LineChartSample3State();

}

class _LineChartSample3State extends State<LineChartSample3> {  List<Color> gradientColors = [
  const Color(0xFFFFA200),
  const Color(0xFFFBD491),
];

bool showAvg = false;


@override
Widget build(BuildContext context) {

  return Stack(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 1.70,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Color(0xFFE5E5E5)),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(
              showAvg ? avgData() : mainData( widget.dataPassed, widget.xMax, widget.yMax, widget.intervalCheck ),
            ),
          ),
        ),
      ),
    ],
  );
}

// datum is the data passed through, currently stored in global variables,
// xMax is referring to the button pressed in the HomeCards widget
LineChartData mainData( datum, xMax, yMax, intervalCheck) {
  final spots = datum;
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xFF959595),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xFF959595),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 4,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: intervalCheck,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        reservedSize: 32,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: xMax,
    minY: 0,
    maxY: yMax,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
          gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}

LineChartData avgData() {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        margin: 8,
        interval: 1,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        reservedSize: 32,
        interval: 1,
        margin: 12,
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 3.44),
          FlSpot(2.6, 3.44),
          FlSpot(4.9, 3.44),
          FlSpot(6.8, 3.44),
          FlSpot(8, 3.44),
          FlSpot(9.5, 3.44),
          FlSpot(11, 3.44),
        ],
        isCurved: true,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.1)!,
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.1)!,
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!
              .withOpacity(0.2),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!
              .withOpacity(0.2),
        ]),
      ),
    ],
  );
}
}

