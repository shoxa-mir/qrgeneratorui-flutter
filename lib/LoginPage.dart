// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrgeneratorui/SignUpPage.dart';

import 'HomePage.dart';
import 'firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  late TextEditingController _emailInput;
  late TextEditingController _passwordInput;
  String? message;

  @override
  void initState() {
    _emailInput = TextEditingController();
    _passwordInput = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:
            Colors.white.withOpacity(0.3), //You can make this transparent
        elevation: 0.0, //No shadow
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Center(
                          child: SizedBox(
                              width: 200,
                              height: 150,
                              child: Image.asset(
                                  'assets/qrgenerator(purple).png')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _emailInput,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _passwordInput,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter your password'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //TODO FORGOT PASSWORD SCREEN GOES HERE
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.deepPurpleAccent, fontSize: 15),
                        ),
                      ),
                      hintMessage(message),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            final email = _emailInput.text;
                            final password = _passwordInput.text;
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                            } catch (e) {
                              setState(() {
                                message = "Invalid email or password";
                              });
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0.15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('New User? '),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SingUpPage()));
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          }),
    );
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
}
