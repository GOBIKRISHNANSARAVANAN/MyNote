import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynote/ReportScreen.dart';

import 'Add.dart';
import 'SecondRoute.dart';
import 'ThirdRoute.dart';
//import 'package:untitled/view.dart';

//import 'ReportScreen.dart';
//import 'SecondRouteReport.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int availbal=0;
  int availdue=0;
  final user = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState()
  {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!.email;
    FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
      availbal=documentSnapshot.get("Avail balance");
      print(availbal);
    });
    FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot)
    {
      availdue=documentSnapshot.get("Avail due");
      print(availdue);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: SizedBox(
                    height: 75,
                    child: Text("Hi,",style: TextStyle(fontSize: 30),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color:Colors.blue
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.blue
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("$availbal",style: TextStyle(color: Colors.white),),
                              Text("Available Balance",style:TextStyle(color:Colors.white)),
                             /*TextButton(onPressed: (){
                                setState(() {
                                  FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                                    if (documentSnapshot.exists) {
                                      availbal=documentSnapshot.get("Avail balance");
                                    }
                                  });
                                });
                              }, child: Text("View Balance",style: TextStyle(color: Colors.white),)),*/

                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          height: 100,
                          width: 150,
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.blue
                          ),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$availdue",style: TextStyle(color: Colors.white),),
                            Text("Available Dues",style: TextStyle(color: Colors.white),),
                            /*TextButton(
                              onPressed: (){
                                setState(() {
                                  FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot)
                                  {
                                    availdue=documentSnapshot.get("Avail due");
                                    print(availdue);
                                  });
                                });
                              },child: Text("View Dues",style: TextStyle(color: Colors.white),),
                            ),*/

                          ],
                        ),
                        )
                      ],
                    ),
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      final user = FirebaseAuth.instance.currentUser!.email;
                      FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                        availbal=documentSnapshot.get("Avail balance");
                        print(availbal);
                      });
                      FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot)
                      {
                        availdue=documentSnapshot.get("Avail due");
                        print(availdue);
                      });
                    });
                  }, child: Text("View Details"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  height: 300,
                  width: double.infinity,
                  child:SingleChildScrollView(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            isScrollable:true,
                            tabs: [
                              Tab(child: Text("Income",style:TextStyle(color:Colors.black)),),
                              Tab(child: Text("Expenses",style: TextStyle(color: Colors.black),),)
                            ],
                          ),
                          Container(
                            height: 200,
                            child: TabBarView(
                              children: [
                                SecondRoute(),
                                ThirdRoute()
                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 25,
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportScreen()),
                    );
                  });
                }, child: Text("Get Report")),
              ),
            )
          ],
        ),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddScreen()),
            );
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
