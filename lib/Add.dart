import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final user = FirebaseAuth.instance.currentUser!.email;
  DateTime? pickedDate;
  TextEditingController DescriptionController=new TextEditingController();
  TextEditingController AmountController=new TextEditingController();
  String dropdownvalue1 = 'Income';
  String dropdownvalue2="Regular";
  String dropdownvalue3="Regular";
  // List of items in our dropdown menu
  var items1 = [
    'Income',
    'Expenses',
  ];
  var items2=[
    'Regular',
    'Bonous',
    'Dues'
  ];
  var items3=[
    'Regular',
    'Savings',
    'Dues'
  ];
  bool flag2=false;
  bool flag3=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: DropdownButtonFormField(

                  // Initial Value
                  value: dropdownvalue1,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue1 = newValue!;
                      if(dropdownvalue1=="Income")
                        {
                          flag2=true;
                          flag3=false;
                        }
                      else
                        {
                          flag2=false;
                          flag3=true;
                        }
                    });
                  },
                  // Array list of items
                  items: items1.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: DropdownButtonFormField<String>(
                value: dropdownvalue2,
                onChanged: flag2 ? (value) => setState(() => dropdownvalue2 = value!) : null,
                items: items2.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: DropdownButtonFormField<String>(
                value: dropdownvalue3,
                onChanged: flag3 ? (value) => setState(() => dropdownvalue3 = value!) : null,
                items: items3.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller:DescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                  labelText: "Description"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller:AmountController,
                decoration: InputDecoration(
                  border:OutlineInputBorder(),
                  hintText: "Amount",
                  labelText: "Amount"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 30,
                width: double.infinity,
                child: ElevatedButton(
                  child:Text("Select Date"),
                  onPressed: (){
                    setState(() async {
                          await showDatePicker(
                          context: context, //context of current state
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      ).then((value) {
                        setState(() {
                          pickedDate=value!;
                        });
                      });
                      print(pickedDate.toString());
                      
                    });
                  }
                ),
              ),
            ),
            Text('$pickedDate'),
            Padding(
              padding:EdgeInsets.all(30.0),
              child:Container(
                width: double.infinity,
                height:30,
                child:ElevatedButton(
                  child:Text("Submit"),
                  onPressed:(){
                    setState(() async {
                      //String email=emailController.text.toString();
                      String description=DescriptionController.text.toString();
                      String category=dropdownvalue1.toString();
                      String incomeCategory=dropdownvalue2.toString();
                      String expenceCategory=dropdownvalue3.toString();
                      int amount=int.parse(AmountController.text.toString());
                      if((category=="Income")&&((incomeCategory=="Regular")||(incomeCategory=="Bonous")))
                      {
                        int availbal=0;
                        int bal=0;
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            availbal=documentSnapshot.get("Avail balance");
                          }
                        });
                        CollectionReference ref=FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata");
                        ref.add({
                          "description":description,
                          "category":category,
                          "Income Category":incomeCategory,
                          "Amount":amount,
                          "Date":pickedDate,
                        });
                        await Future.delayed(const Duration(milliseconds: 2500));
                        bal=amount+availbal;
                        CollectionReference users = FirebaseFirestore.instance.collection(user!);
                        users.doc("data").update({'Avail balance':bal})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));

                      }
                      else if((category=="Income")&&(incomeCategory=="Dues"))
                      {
                        int initbal=0;
                        int initdue=0;
                        int availbal=0;
                        int availdue=0;
                        int bal=0;
                        int due=0;
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            initbal=documentSnapshot.get("Initial balance");
                            availbal=documentSnapshot.get("Avail balance");
                          }
                        });
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            initdue=documentSnapshot.get("Initial Due");
                            availdue=documentSnapshot.get("Avail due");
                          }
                        });
                        CollectionReference ref=FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata");
                        ref.add({
                          "description":description,
                          "category":category,
                          "Income Category":incomeCategory,
                          "Amount":amount,
                          "Date":pickedDate
                        });
                        await Future.delayed(const Duration(milliseconds: 2500));
                        bal=amount+availbal;
                        CollectionReference user1 = FirebaseFirestore.instance.collection(user!);
                        user1.doc("data").update({'Avail balance':bal})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                        due=amount+availdue;
                        CollectionReference user2 = FirebaseFirestore.instance.collection(user!);
                        user2.doc("data").update({'Avail due':due})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                      }
                      else if((category=="Expenses")&&((expenceCategory=="Regular")))
                      {
                        int availbal=0;
                        int bal=0;
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            availbal=documentSnapshot.get("Avail balance");
                          }
                        });
                        CollectionReference ref=FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata");
                        ref.add({
                          "description":description,
                          "category":category,
                          "Expense Category":expenceCategory,
                          "Amount":amount,
                          "Date":pickedDate
                        });
                        await Future.delayed(const Duration(milliseconds: 2500));
                        bal=availbal-amount;
                        CollectionReference users = FirebaseFirestore.instance.collection(user!);
                        users.doc("data").update({'Avail balance':bal})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                      }
                      else if((category=="Expenses")&&(expenceCategory=="Dues"))
                      {
                        int availbal=0;
                        int availdue=0;
                        int bal=0;
                        int due=0;
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            availbal=documentSnapshot.get("Avail balance");
                          }
                        });
                        FirebaseFirestore.instance.collection(user!).doc("data").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            availdue=documentSnapshot.get("Avail due");
                          }
                        });
                        CollectionReference ref=FirebaseFirestore.instance.collection(user!).doc("userdata").collection("userdata");
                        ref.add({
                          "description":description,
                          "category":category,
                          "Expense Category":expenceCategory,
                          "Amount":amount,
                          "Date":pickedDate
                        });
                        await Future.delayed(const Duration(milliseconds: 2500));
                        bal=availbal-amount;
                        CollectionReference user1 = FirebaseFirestore.instance.collection(user!);
                        user1.doc("data").update({'Avail balance':bal})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                        due=availdue-amount;
                        CollectionReference user2 = FirebaseFirestore.instance.collection(user!);
                        user2.doc("data").update({'Avail due':due})
                            .then((value) => print("User Updated"))
                            .catchError((error) => print("Failed to update user: $error"));
                      }
                    });
                  }
                )
              )
            )
          ],
        ),
      )
    );
  }
}
