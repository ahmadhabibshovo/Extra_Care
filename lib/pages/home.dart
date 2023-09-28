import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'students.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _timecontroller = TextEditingController();
  final db = FirebaseFirestore.instance;
  bool loading = true;
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
                                .collection("Batch")
                                .doc(batch[index].id)
                                .delete()
                                .then((doc) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
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
              title: const Text('Batch Details'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      onChanged: (value) {},
                      controller: _timecontroller,
                      decoration: const InputDecoration(hintText: "Time"),
                    ),
                    TextButton(
                        onPressed: () {
                          // Create a new user with a first and last name
                          final batch = <String, dynamic>{
                            "ID": (id + 1).toString(),
                            "Time": _timecontroller.text,
                          };

                          db
                              .collection("Batch")
                              .add(batch)
                              .then((DocumentReference doc) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (Route<dynamic> route) => false,
                            );
                          });
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ));
        });
  }

  Future<void> _displayTextInputDialogEdit(BuildContext context, Index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Edit Time'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      onChanged: (value) {},
                      controller: _timecontroller,
                      decoration: const InputDecoration(hintText: "Time"),
                    ),
                    TextButton(
                        onPressed: () {
                          // Create a new user with a first and last name

                          final washingtonRef =
                              db.collection("Batch").doc(batch[Index].id);
                          washingtonRef.update(
                              {"Time": _timecontroller.text}).then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (Route<dynamic> route) => false,
                            );
                          });
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ));
        });
  }

  var batch;
  var id;
  Future<void> getData() async {
    await db.collection("Batch").orderBy("ID").get().then((event) {
      batch = event.docs;
      id = batch.length;
    });
  }

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text("Batch",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white)),
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: batch.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onDoubleTap: () {
                        _displayTextInputDialogEdit(context, index);
                      },
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Student(
                                    batch: batch[index].data()["ID"].toString(),
                                  )),
                          (Route<dynamic> route) => false,
                        );
                      },
                      onLongPress: () {
                        _displayConfermdl(context, index);
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Batch : ${batch[index].data()["ID"].toString()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                            Text(
                                "Time : ${batch[index].data()["Time"].toString()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
