// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrgeneratorui/LoginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:qrgeneratorui/QrShowPage.dart';
import 'package:qrgeneratorui/ad_helper.dart';
import 'package:qrgeneratorui/firebase_options.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var urlController = TextEditingController();
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  late bool userLogged = false;
  String _fileText = "";
  static late String url;
  late String? message;
  int counter = 5;

  @override
  void dispose() {
    _bannerAd?.dispose();
    urlController.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    _loadRewardedAd();
    message = null;
    urlController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: null,
          body: FutureBuilder(
              future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  default:
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Center(
                              child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.asset(
                                      'assets/qrgenerator(home).png')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 15),
                            child: TextFormField(
                              cursorColor: Colors.white,
                              controller: urlController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Url adress',
                                  hintText: 'Url to generate QR-code'),
                              validator: (uri) =>
                                  uri != null && Uri.parse(uri).isAbsolute
                                      ? "Invalid url"
                                      : null,
                            ),
                          ),
                          const Text(
                            'or',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextButton(
                              onPressed: () async => _pickFile(),
                              child: const Text(
                                'Select File',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                            ),
                          ),
                          hintMessage(message),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextButton(
                              onPressed: () async {
                                url = urlController.text;
                                if (url.length > 1 || _fileText.length > 1) {
                                  if (counter > 0) {
                                    setState(() {
                                      counter--;
                                    });
                                    print(counter.toString());
                                    log("[DEBUG] User logged in $userLogged");
                                    if (kDebugMode) {
                                      print("User logged in $userLogged");
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const QrShowPage()));
                                    if (kDebugMode) {
                                      print(_fileText);
                                      print("Generate");
                                    }
                                  } else {
                                    _rewardedAd?.show(
                                        onUserEarnedReward: (_, reward) {
                                      setState(() {
                                        counter = 5;
                                      });
                                    });
                                  }
                                } else {
                                  setState(() {
                                    message =
                                        "Please enter url or select a file";
                                  });
                                }
                              },
                              child: const Text(
                                'Generate QR-code',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("$counter free attempts left")),
                          loginHint(),
                          const SizedBox(
                            height: 150,
                          ),
                          logoutButton(),
                          if (_bannerAd != null)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: _bannerAd!.size.width.toDouble(),
                                height: _bannerAd!.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd!),
                              ),
                            ),
                        ],
                      ),
                    );
                  // default:
                  //   return Text("Loading...");
                }
              }),
        ));
  }

  void isUserLogged() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    User? userUid = FirebaseAuth.instance.currentUser;
    // print(user_uid!.displayName);
    if (userUid == null) {
      setState(() {
        userLogged = false;
      });
    } else {
      setState(() {
        userLogged = true;
      });
    }
  }

  Align logoutButton() {
    isUserLogged();
    if (userLogged != false) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: 30,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: TextButton(
            onPressed: () async => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure to sing out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      User? userUid = FirebaseAuth.instance.currentUser;
                      if (kDebugMode) {
                        print(userUid!.displayName);
                      }
                      isUserLogged();
                      Navigator.pop(context, 'Yes');
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 40,
        ),
      );
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      if (kDebugMode) {
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
      }

      File file_ = File(result.files.single.path!);
      setState(() {
        _fileText = file_.path;
      });
    } else {}
  }

  Widget hintMessage(String? message) {
    if (message != null) {
      return Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 15),
      );
    } else {
      return Text(" ");
    }
  }

  Widget loginHint() {
    if (userLogged == false) {
      return Align(
        alignment: const AlignmentDirectional(1, 0.15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 1),
              child: TextButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: const Text(
                  'Login',
                  style:
                      TextStyle(color: Colors.deepPurpleAccent, fontSize: 15),
                ),
              ),
            ),
            const Text('to upload files larger than 10 MB.'),
          ],
        ),
      );
    } else {
      return const Align(
          alignment: AlignmentDirectional(0, 0.15),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Logged in",
              style: TextStyle(
                  color: Color.fromARGB(255, 71, 53, 121),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ));
    }
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
}
