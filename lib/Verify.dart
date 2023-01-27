import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Home.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  User? user1 = FirebaseAuth.instance.currentUser;
  @override
  void initState()
  {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3),
              (_) => checkEmailVerified()
      );
    }
  }
  void dispose()
  {
    timer?.cancel();
    super.dispose();
  }
  Future checkEmailVerified() async
  {
    await FirebaseAuth.instance.currentUser!.reload();
    setState((){
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }
  Future sendVerificationEmail() async
  {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    setState(() => canResendEmail =  false);
    await Future.delayed(Duration(seconds:5));
    setState(() =>canResendEmail = true);
  }

  Widget build(BuildContext context) =>isEmailVerified?Home():
    Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Center(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Email:",style: TextStyle(color: Colors.black),),
                Text(user1!.email.toString(),style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
              ],
            ),

            ElevatedButton(
                onPressed:  canResendEmail?sendVerificationEmail:null,
                child: Text("Send Verfication Mail")),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Didn't got a verfication email?"),
                TextButton(
                    onPressed: () {
                      setState(() {

                      });
                    },
                    child: Text("Wrong Email Address"))
              ],
            ),
          ],
        ),
      ),
    );
  }

