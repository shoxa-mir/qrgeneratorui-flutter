// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrgeneratorui/firebase_options.dart';
import 'package:qrgeneratorui/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';

class SingUpPage extends StatefulWidget {
  @override
  SingUpState createState() => SingUpState();
}

class SingUpState extends State<SingUpPage> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _password;
  String? message;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text(''),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  elevation: 0.0,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Center(
                          child: SizedBox(
                              width: 200,
                              height: 150,
                              child: Image.asset(
                                  'assets/qrgenerator(purple).png')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Enter your display name'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter your email address'),
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: ListTile(
                              subtitle: TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                controller: _password,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Enter secure password'),
                                validator: (value) =>
                                    value != null && value.length < 6
                                        ? 'Enter min. 6 characters'
                                        : null,
                              ),
                            )),
                            Expanded(
                                child: ListTile(
                              subtitle: TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    hintText: 'Re-enter secure password'),
                                validator: (value) =>
                                    value != null && value == _password.text
                                        ? "Passwords doesn't match"
                                        : null,
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      hintMessage(message),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            log("Email: $email");
                            log("Password: $password");
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                              User? user = userCredential.user;
                              user!.updateDisplayName(_name.text);
                            } catch (e) {
                              log(e.toString());
                              if (e.toString() ==
                                  "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                                setState(() {
                                  message = "Email is already in use";
                                });
                              } else if (e.toString() ==
                                  "[firebase_auth/weak-password] Password should be at least 6 characters") {
                                setState(() {
                                  message =
                                      "Password should be at least 6 characters";
                                });
                              } else if (e.toString() ==
                                  "[firebase_auth/invalid-email] The email address is badly formatted.") {
                                setState(() {
                                  message = "Invalid email";
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 175,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0.15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already Registered? '),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Login to Account',
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
                ),
              );
            default:
              return Text("Loading...");
          }
        });
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
