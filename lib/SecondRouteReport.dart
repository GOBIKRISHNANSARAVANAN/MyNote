import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SecondRouteReport extends StatefulWidget {
  const SecondRouteReport({Key? key}) : super(key: key);

  @override
  State<SecondRouteReport> createState() => _SecondRouteReportState();
}

class _SecondRouteReportState extends State<SecondRouteReport> {
  final user = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState()
  {
    super.initState();
    FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata").where("Date",isGreaterThanOrEqualTo: pickedDate1).where("Date",isLessThanOrEqualTo:pickedDate2).get().then((value) {
      for (var doc in value.docs) {
        // Getting data directly

        // Getting data from map
        Map<String, dynamic> data = doc.data();
        int amount = data['Amount'];
        String category=data["category"];
        if(category=="Income")
        {
          docs.add(data);
        }

        print(amount);
        docs.clear();
      }
    });
    print(docs.length);
  }
  DateTime? pickedDate1;
  DateTime? pickedDate2;
  final List docs=[];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 25,
                width: double.infinity,
                child: ElevatedButton(
                    child:Text("Start Date"),
                    onPressed: (){
                      setState(() async {
                        await showDatePicker(
                            context: context, //context of current state
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101)
                        ).then((value) {
                          setState(() {
                            pickedDate1=value!;
                          });
                        });
                        print(pickedDate1.toString());
                      });
                    }
                ),
              ),
            ),
            Text(pickedDate1.toString()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 25,
                width: double.infinity,
                child: ElevatedButton(
                    child:Text("End Date"),
                    onPressed: (){
                      setState(()  async {
                        await showDatePicker(
                            context: context, //context of current state
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101)
                        ).then((value) {
                          setState(() {
                            pickedDate2=value!;
                          });
                        });
                        print(pickedDate2.toString());
                        FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata").where("Date",isGreaterThanOrEqualTo: pickedDate1).where("Date",isLessThanOrEqualTo:pickedDate2).get().then((value) {
                          for (var doc in value.docs) {
                            // Getting data directly

                            // Getting data from map
                            Map<String, dynamic> data = doc.data();
                            int amount = data['Amount'];
                            String category=data["category"];
                            if(category=="Income")
                            {
                              docs.add(data);
                            }

                            print(amount);

                          }
                        });

                      });
                    }
                ),
              ),
            ),
            Text(pickedDate2.toString()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 25,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (){
                      setState(() {

                        FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata").where("Date",isGreaterThanOrEqualTo: pickedDate1).where("Date",isLessThanOrEqualTo:pickedDate2).get().then((value) {
                          for (var doc in value.docs) {
                            // Getting data directly

                            // Getting data from map
                            Map<String, dynamic> data = doc.data();
                            int amount = data['Amount'];
                            String category=data["category"];
                            if(category=="Income")
                            {
                              docs.add(data);
                            }

                            print(amount);

                          }
                        });
                        print(docs.length);
                      });
                    },
                    child:Text("Generate")
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border:TableBorder.all(),
                columnWidths: const <int,TableColumnWidth>{
                  1:FixedColumnWidth(140)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                      children: [
                        TableCell(
                            child: Container(
                                child:Text("Description",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)
                            )
                        ),
                        TableCell(
                            child: Container(
                                child:Text("Amount",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)
                            )
                        ),
                        TableCell(
                            child: Container(

                                child:Text("Date",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)
                            )
                        ),
                      ]
                  ),
                  for(var i=0;i<docs.length;i++)...[
                    TableRow(
                        children: [
                          TableCell(
                              child: Center(
                                child: Text(docs[i]['description']),
                              )
                          ),
                          TableCell(
                              child: Center(
                                child: Text(docs[i]['Amount'].toString()),
                              )
                          ),
                          TableCell(
                              child: Container(
                                child: Text((docs[i]['Date']).toDate().toString().substring(0,10)),
                              )
                          )
                        ]
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
