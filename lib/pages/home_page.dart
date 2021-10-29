import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ml/charts/chart_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List actualData = [];
  List predictedResult = [];
  TextEditingController _inputNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showInputBottomSheet(context, "a", "b");
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('collection01').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            actualData = (snapshot.data!.docs[0].data() as Map)["data"];
            predictedResult =
                (snapshot.data!.docs[1].data() as Map)["forecast"];

            return Stack(
              children: [
                Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "お風呂",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (actualData.length != 0)
                          ? SizedBox(
                              height: 300,
                              width: deviceWidth,
                              child: chartBody(actualData, predictedResult),
                            )
                          : Text(
                              "データがありません",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
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
}
