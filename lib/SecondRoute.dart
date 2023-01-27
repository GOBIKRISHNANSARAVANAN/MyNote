import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {

  final user1 = FirebaseAuth.instance.currentUser!.email;
  //final Stream<QuerySnapshot> user = FirebaseFirestore.instance.collection(user1).doc("userdata").collection("userdata").where("category",isEqualTo: "Income").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(user1!).doc("userdata").collection("userdata").where("category",isEqualTo: "Income").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
          {
            print("something went wrong");
          }
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List docs=[];
          snapshot.data!.docs.map((DocumentSnapshot document)
          {
            Map a=document.data() as Map<String,dynamic>;
            docs.add(a);
            a['id']=document.id;
          }).toList();
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            child: SingleChildScrollView(
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
          );
        }
    );
  }

}
