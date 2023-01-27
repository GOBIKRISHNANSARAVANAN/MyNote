import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynote/RegisterScreen.dart';
import 'package:mynote/Verify.dart';
class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController EmailController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Center(
        child:Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(30),
                child: TextField(
                    controller: EmailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        hintText: "Email",
                        suffixIcon: Icon(Icons.mail)))),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      User? user = FirebaseAuth.instance.currentUser;
                      FirebaseAuth.instance.sendPasswordResetEmail(
                        email: EmailController.text.toString(),
                      ).then((value) {
                        setState(() {
                          Fluttertoast.showToast(
                              msg: "Password reset email was sent to your mail",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              fontSize: 16.0);
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          Fluttertoast.showToast(msg: "Error Occured",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          fontSize: 16.0);
                        });
                      });
                    });
                  },
                  child: Text("Reset Here"),
                )
          ],
        )
      ),
    );
  }
}

