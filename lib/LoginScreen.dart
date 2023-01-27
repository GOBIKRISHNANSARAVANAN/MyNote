// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynote/RegisterScreen.dart';
import 'package:mynote/Verify.dart';

import 'Home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool value = true;
  TextEditingController EmailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("My Note"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ignore: prefer_const_constructors
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                // ignore: prefer_const_constructors
                child: Text(
                  "Welcome !!!",
                  style: TextStyle(fontSize: 60),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                  child: Text(
                    "Login Here",
                    style: TextStyle(fontSize: 30),
                  )),
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                      controller: EmailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Email",
                          suffixIcon: Icon(Icons.mail)))),
              Padding(
                padding: const EdgeInsets.all(30),
                child: TextField(
                  controller: PasswordController,
                  obscureText: value,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              value = !value;
                            });
                          },
                          icon: Icon(value
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Container(
                  height: 30,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: EmailController.text,
                                password:PasswordController.text
                            ).then((value) {
                              setState(() {
                                bool isEmailVerfied=FirebaseAuth.instance.currentUser!.emailVerified;
                                if(isEmailVerfied==true)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VerifyScreen()),
                                    );
                                  }

                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              Fluttertoast.showToast(
                                  msg: "No user found for that email",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 16.0);
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              Fluttertoast.showToast(
                                  msg: "Wrong password provided for that user",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 16.0);
                              print('Wrong password provided for that user.');
                            }
                          }
                        });
                      },
                      child: Text("Login")),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Forgot Password?"),
                  TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text("Reset Here"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      });
                    },
                    child: Text("Create Account"),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
