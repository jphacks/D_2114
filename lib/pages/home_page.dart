import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ml/charts/chart_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List actualData = [];
  List predictedData = [];
  double meanResult = 0;
  double varianceResult = 0;
  TextEditingController _inputNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showInputBottomSheet(context, "a", "b");
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('collection01').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            actualData = (snapshot.data!.docs[0].data() as Map)["data"];
            Map predictedResult = snapshot.data!.docs[1].data() as Map;
            predictedData = predictedResult["forecast"];
            meanResult = predictedResult["mean"];
            varianceResult = predictedResult["variance"];

            return Stack(
              children: [
                Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  color: Colors.transparent,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.stacked_line_chart_rounded,
                                      color: Colors.black,
                                      size: 33,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Forecast Result",
                                        style: GoogleFonts.museoModerno(
                                          fontSize: 24,
                                          color: Colors.white,
                                          // height: 0.5,
                                        ),
                                      ),
                                      Text(
                                        "寮のお風呂の混雑状況の予想",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          height: 0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.more_horiz_rounded,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          (actualData.length != 0)
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFF1B1B1F),
                                  ),
                                  height: 270,
                                  width: deviceWidth,
                                  child: chartBody(actualData, predictedData),
                                )
                              : Text(
                                  "データがありません",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Detail",
                              style: GoogleFonts.museoModerno(
                                fontSize: 27,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 18),
                        children: [
                          _detailCard(Color(0xFFFE7549), Color(0xFFFF2E68),
                              "Mean", "平均", meanResult),
                          _detailCard(Color(0xFF1353F3), Color(0xFF44C2FF),
                              "Variance", "分散", varianceResult),
                          _detailCard(Color(0xFF16D285), Color(0xFF3DEF8F),
                              "Mean", "平均", 5),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showInputBottomSheet(
      BuildContext context, String title, String message) {
    double deviceWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '現在のお風呂の人数を入力しましょう',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: '人数'),
                        autofocus: true,
                        controller: _inputNumberController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    TextButton(
                        onPressed: addDataToFirestore, child: Text("submit")),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void addDataToFirestore() async {
    DateTime lastTime = actualData.last["timestamp"].toDate();
    DateTime newTime = lastTime.add(Duration(hours: 1));
    int inputValue = int.parse(_inputNumberController.text);
    await FirebaseFirestore.instance
        .collection("collection01")
        .doc("document01")
        .update({
      'data': FieldValue.arrayUnion([
        {
          "timestamp": newTime,
          "value": inputValue,
        }
      ])
    });
    Navigator.of(context).pop();
    _inputNumberController.clear();
  }

  Widget _detailCard(
      Color color1, Color color2, String title1, String title2, double value) {
    String unit = "";
    if (title1 == "Mean") {
      unit = "people/hour";
    } else if (title1 == "Variance") {
      unit = "people^2/hour";
    }

    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              title1,
              style: GoogleFonts.museoModerno(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              title2,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            Center(
              child: Text(
                value.toInt().toString(),
                style: GoogleFonts.museoModerno(
                  fontSize: 80,
                  color: Colors.white,
                  letterSpacing: -3,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                unit,
                style: GoogleFonts.museoModerno(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
