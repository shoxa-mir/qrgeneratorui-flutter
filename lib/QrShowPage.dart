// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qrgeneratorui/HomePage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrShowPage extends StatefulWidget {
  const QrShowPage({super.key});

  @override
  QrShowState createState() => QrShowState();
}

class QrShowState extends State<QrShowPage> {
  String inputData = HomePageState.url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white.withOpacity(0.3),
        elevation: 0.0,
      ),
      body: FutureBuilder(builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: Image.asset('assets/qrgenerator(home).png')),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.75),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: QrImage(
                      data: checkUrl(inputData),
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 11, 54, 90),
                      embeddedImage:
                          Image.asset('assets/qrgenerator.png').image,
                      embeddedImageStyle:
                          QrEmbeddedImageStyle(size: Size(30, 30), color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Url address: ",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: SelectableText(
                  checkUrl(inputData),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      }),
    );
  }

  String checkUrl(String inputdata) {
    if (inputData[0] == ("https://")) {
      log(inputdata);
      return inputdata;
    } else {
      log("https://$inputData");
      return "https://$inputData";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
