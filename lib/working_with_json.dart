
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';


// final parsedJson = jsonDecode(allData[0]);
List jsonScoring(allData) {
  List answerAsInts = [];
  List preAnswerAsInts = [];
  List flSpotsAnswers = [];
  List proWhich = [];
  List jsonObjects = [];
  // print("DATA LENGTH: ${allData.length}");
  // print("DATA: $allData");
  for (var file in allData) {
    // print("FILE: $file");
    // print("allData: $allData");
    final parsedJson = jsonDecode(file);
    // print('${parsedJson.runtimeType} : $parsedJson');
    // 0 is changing
    var storedAnswers = parsedJson['report'][1]['item'];
    // print("CHECKING STORED ANSWEER: ${storedAnswers.length}");
    preAnswerAsInts = [];
    for (var i = 0; i < storedAnswers.length; i++) {
      String answer = storedAnswers[i]['item'][0]['answer'][0]['valueString'];
      // print("$answer");
      if (answer == 'Never') {
        preAnswerAsInts.add(4);

      } else if (answer == 'Occasionally') {
        preAnswerAsInts.add(3);


      } else if (answer == 'Sometimes') {
        preAnswerAsInts.add(2);


      } else if (answer == 'Often') {
        preAnswerAsInts.add(1);

      } else if (answer == 'Always') {
        preAnswerAsInts.add(0);
      } else {
        print("Idk what happened but one the answer choices is not there");
      }
    }
    // print("PRE: $preAnswerAsInts");
    // appending file score to entire score
    answerAsInts.add(preAnswerAsInts);
    // print("ANSWEASINT : $answerAsInts ");
    // Checking which test they are taking
    var proType = parsedJson['report'][0].keys;
    // Still need to iterate through this array, for some reason you can iterate through
    // it like a normal list

    // Getting the PRO type, this is stored in proType variable
    proType = proType.toString().split(',')[2];
    proType = proType.split(')')[0];
    // print(proType);
    proWhich.add(proType);
    // all the scored answers stored in a list
    // print("ANSWERS: $answerAsInts");
  }
  List averages = [];
  for (var i = 0; i < answerAsInts.length; i++) {
    List<FlSpot> flSpotTemp = [];
    // print(answerAsInts);
    num average = 0;
    for (var j = 0; j < answerAsInts[i].length; j++) {
      average += answerAsInts[i][j];
      flSpotTemp.add((FlSpot(j.toDouble(), answerAsInts[i][j].toDouble())));
    }
    averages.add(average / answerAsInts[i].length);
    flSpotsAnswers.add(flSpotTemp);
  }
  flSpotsAnswers.add(averages);
  // print(answerAsInts);
  return (flSpotsAnswers);
}



//   for (var i = 0; i < xAxis.length; i++) {
// mySpots.add((FlSpot(i.toDouble(),yAxis[i])));
// }
