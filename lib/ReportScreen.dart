import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SecondRouteReport.dart';
import 'ThirdRouteReport.dart';
class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? pickedDate1;
  DateTime? pickedDate2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  height: 700,
                  width: double.infinity,
                  child:SingleChildScrollView(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            isScrollable:true,
                            tabs: [
                              Tab(child: Text("Income",style: TextStyle(color: Colors.black),),),
                              Tab(child: Text("Expense",style: TextStyle(color: Colors.black),))
                            ],
                          ),
                          Container(
                            height: 700,
                            child: TabBarView(
                              children: [
                                SecondRouteReport(),
                                ThirdRouteReport()
                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
