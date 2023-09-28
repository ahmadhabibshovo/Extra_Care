import 'package:extra_care/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telephony/telephony.dart';

class Student extends StatefulWidget {
  const Student({super.key, required this.batch});

  @override
  State<Student> createState() => _StudentState();
  final batch;
}

class _StudentState extends State<Student> {
  final _namecontroller = TextEditingController();
  final _spcontroller = TextEditingController();

  final db = FirebaseFirestore.instance;
  final Telephony telephony = Telephony.instance;
  var students;
  var id;
  final presnt = [];
  final absent = [];
  bool loading = true;
  List tik = [];
  List cross = [];

  sentMess(messeage, numbers) {
    for (var number in numbers) {
      telephony
          .sendSms(to: number[1], message: " Dear ${number[0]}, \n messeage")
          .then((value) {});
    }
  }

  Future<void> _displayConferm(BuildContext context, text) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Send Message'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            sentMess(text, presnt);
                            sentMess(text, absent);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Future<void> _displayConfermdl(BuildContext context, index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Center(child: Text('Delete ????')),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            db
                                .collection("Students")
                                .doc(students[index].id)
                                .delete()
                                .then((doc) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Student(batch: widget.batch)),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Student Details'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextField(
                          onChanged: (value) {},
                          controller: _namecontroller,
                          decoration: const InputDecoration(hintText: "Name"),
                        ),
                        TextField(
                          onChanged: (value) {},
                          controller: _spcontroller,
                          decoration: const InputDecoration(
                              hintText: "Student Contacts"),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Create a new user with a first and last name
                        final students = <String, dynamic>{
                          "ID": id + 1,
                          "Batch": widget.batch,
                          "Name": _namecontroller.text,
                          "SPhone": _spcontroller.text,
                        };

                        db
                            .collection("Students")
                            .add(students)
                            .then((DocumentReference doc) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Student(
                                      batch: widget.batch,
                                    )),
                            (Route<dynamic> route) => false,
                          );
                        });
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Future<void> getData() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("Students")
        .where("Batch", isEqualTo: widget.batch)
        .orderBy("ID")
        .get()
        .then((event) {
      students = event.docs;
      id = students.length;
    });
  }

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        loading = false;
      });
      tik = List<bool>.filled(id, false, growable: true);
      cross = List<bool>.filled(id, false, growable: true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text(
            "Students",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _displayTextInputDialog(context);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: loading
          ? Container()
          : Column(
              children: [
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          _displayConfermdl(context, index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          students[index]
                                              .data()["Name"]
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              presnt.add([
                                                students[index].data()["Name"],
                                                students[index].data()["SPhone"]
                                              ]);

                                              setState(() {
                                                tik[index] = true;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.check,
                                              color: tik[index]
                                                  ? const Color.fromARGB(
                                                      255, 146, 245, 196)
                                                  : Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              absent.add([
                                                students[index].data()["Name"],
                                                students[index].data()["SPhone"]
                                              ]);

                                              setState(() {
                                                cross[index] = true;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: cross[index]
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          _displayConferm(context, 'Start Text');
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Start Alert',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _displayConferm(context, "End Text");
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'End Aler',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
