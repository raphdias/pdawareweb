import 'dart:async';
import 'package:example/working_with_json.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart';

import 'chart_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options_storage.dart';

// NOTE:
// jsonScoring not only send over all data points,
// but at the last piece is the averages... so when plotting
// make sure to add a "-1" to the index, this way it doesn't not try
// to plot the averages


// Currently we just take userID and match them between
// current user on the web and the name of the report
// only using PROs in this version....


// List xAxis = [1,2,3,4,5,6,7,8,9];
// List yAxis = [1,3,2,4,2,3,4,3,2,2,4,2,3,3];


late List coordinates = [];
String linkList = '';
List<String> allData = [];
List<String> allPerformanceData = [];
List<String> pdfNames = [];
List<String> performanceNames = [];
late final parsedJson;
List answerAsInts = [];
List mySpots = [];
List<FlSpot> yData = [];
String userID = FirebaseAuth.instance.currentUser!.uid;
// Connection
firebase_storage.FirebaseStorage rawDataStorage =
firebase_storage.FirebaseStorage.instanceFor(
    bucket: 'raw-json.echowear.org');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: PdAwareFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'RIMCAT PDF Portal',
    home: GetData(),
  ));
}


class GetData extends StatefulWidget {
  const GetData({Key? key}) : super(key: key);

  @override
  _GetDataState createState() => _GetDataState();

}

class _GetDataState extends State<GetData> {

  Future<void> updatePdfList() async {
    print("Updating PDF list");

    firebase_storage.ListResult result = await rawDataStorage.ref().listAll();

    pdfNames = [];
    performanceNames = [];
    // print("File names:");
    result.items.forEach((firebase_storage.Reference ref) {
      // Checking for the current users files in the bucket
      if (ref.name.contains(userID)) {
        if (ref.name.contains("_pd")) {
          pdfNames.add(ref.name);
          print(ref.name);
        }
        if (ref.name.contains("performance")) {
          performanceNames.add(ref.name);
        }
      }
    });
    // Now the we have all their files, we want to get the data from them
    for (var file = 0; file < pdfNames.length; file++) {
      var storageRef = rawDataStorage
          .ref("/${pdfNames[file]}");
      // Getting the url to be parsed
      var link = await storageRef.getDownloadURL();
      linkList = link;
      var _jsonData;
      void fetchData() async {
        try {
          final jsonGet = await get(Uri.parse(linkList));
          // print("JsonGet -> success");
          // print("CURRENT EMAIL ID: ${userID}");
          setState(() {
            _jsonData = jsonGet.body;
            allData.add(_jsonData);
            // print(allData);
            mySpots = (jsonScoring(allData));
            // print("JSON:: $_jsonData");
            // print("MY SPOTS: $mySpots");


          });
        } catch (err) {
          print(err);}
      }
      fetchData();
    }
    for (var file = 0; file < performanceNames.length; file++) {
      var storageRef = rawDataStorage
          .ref("/${performanceNames[file]}");
      // Getting the url to be parsed
      var link = await storageRef.getDownloadURL();
      linkList = link;
      var _jsonPerf;
      void fetchData() async {
        try {
          final jsonGet = await get(Uri.parse(linkList));
          print("JsonGet -> success");
          print("CURRENT EMAIL ID: ${userID}");
          setState(() {
            _jsonPerf = jsonGet.body;
            print("$_jsonPerf");
            allPerformanceData.add(_jsonPerf);
            // print(allData);

          });
        } catch (err) {
          print(err);
        }
      }
      fetchData();
    }
    print("$allPerformanceData -- PERFORMANCE");
    // Decoding and scoring the json data
    // print(mySpots);


    // mySpots = (jsonScoring(allData));


    setState(() {});
  }
  void initState() {
    super.initState();

    // Gets the PDF list once when the page is loaded
    print(allData.length);
    // print(allData);
    if (allData.length == 0) {
      updatePdfList();
      // print(allData);
      // print(mySpots);
    }
  }
  @override
  Widget build(BuildContext context) {
    var myGridView = GridView.builder(
      itemCount: mySpots.length - 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 5/2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [ Container(
            decoration: BoxDecoration(
              // color: Colors.grey,
              // Rounding the corners
              borderRadius: BorderRadius.circular(15),
            ),
            child: LineChartSample3(
              dataPassed: mySpots[index],
              xMax: mySpots[index].length.toDouble(),
              yMax: 4,
              intervalCheck: 1,
            ),
          ),
              ],
        );
      },
    );

return Scaffold(
  body:  Row(

    children: [
      Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: myGridView,
    ),
      Container(
        decoration: BoxDecoration(),
        child: Text("${mySpots[mySpots.length - 1]}"),
      )
    ]
  ),
);


  }
}

