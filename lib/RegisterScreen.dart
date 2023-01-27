// ignore_for_file: prefer_const_constructors, unnecessary_new, non_constant_identifier_names, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynote/Verify.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool Value1 = true;
  bool Value2 = true;

  // ignore: non_constant_identifier_names
  TextEditingController EmailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  TextEditingController InitialBalanceController=new TextEditingController();
  TextEditingController InitialDueController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: EmailController.text,
        password: PasswordController.text,
      ).then((value) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerifyScreen()),
          );
          /*CollectionReference users = FirebaseFirestore.instance.collection(EmailController.text.toString()).doc("data").collection("data");
          users.add({
            'Initial Balance':int.parse(InitialBalanceController.text.toString()),
            'Initial Dues': int.parse(InitialDueController.text.toString()),
            'Total Balance':int.parse(InitialBalanceController.text.toString()),
            'Total Dues':int.parse(InitialDueController.text.toString())
          });*/
          FirebaseFirestore.instance.collection(EmailController.text.toString()).doc("data").set(
              {
                "Initial balance":int.parse(InitialBalanceController.text.toString()),
                "Initial Due":int.parse(InitialDueController.text.toString()),
                "Avail balance":int.parse(InitialBalanceController.text.toString()),
                "Avail due":int.parse(InitialDueController.text.toString())
              }
          ).then((value) => print("added")).onError((error, stackTrace) => "error occured");
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The Password provided is too week",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "This Email is already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child:
                          Text("Register Here", style: TextStyle(fontSize: 30)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        controller: EmailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Email",
                            labelText: "Email",
                            suffixIcon: Icon(Icons.mail)),
                        onFieldSubmitted: (value) {
                          //Validator
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        controller: PasswordController,
                        obscureText: Value1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    Value1 = !Value1;
                                  });
                                },
                                icon: Icon(Value1
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        controller: ConfirmPasswordController,
                        obscureText: Value2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirm Password",
                            hintText: "Confirm Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    Value2 = !Value2;
                                  });
                                },
                                icon: Icon(Value2
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password field cannot be empty";
                          } else if (value != PasswordController.text) {
                            return "Password and Confirm Password must be same";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.all(30.0),
                      child: TextFormField(
                        controller: InitialBalanceController,
                        decoration: InputDecoration(
                          border:OutlineInputBorder(),
                          labelText: "Initial Balance",
                          hintText: "Amount which we have if not enter 0"
                        ),
                        onFieldSubmitted: (value){},
                        validator:(value){
                          if(value==null||value.isEmpty)
                            {
                              return "Must not be blank";
                            }
                          return null;
                        }
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.all(30),
                      child: TextFormField(
                        controller:InitialDueController,
                        decoration: InputDecoration(
                          border:OutlineInputBorder(),
                          labelText: "Initial Dues",
                          hintText: "Dues which we have if not enter 0"
                        ),
                        onFieldSubmitted: (value){},
                        validator: (value){
                          if(value==null||value.isEmpty)
                            {
                              return "Must not be blank";
                            }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => _submit(),
                              child: Text("Register Here")),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
