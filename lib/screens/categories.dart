import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Categories());
}

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCategoriesPage(),
    );
  }
}

class MyCategoriesPage extends StatefulWidget {
  const MyCategoriesPage({Key? key}) : super(key: key);

  @override
  State<MyCategoriesPage> createState() => _MyCategoriesPageState();
}

class _MyCategoriesPageState extends State<MyCategoriesPage> {
  final Stream<QuerySnapshot> BlogPost =
      FirebaseFirestore.instance.collection('BlogPost').snapshots();
  var tags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Blog-App'),
        // ),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
                height: (MediaQuery.of(context).size.height),
                child: Column(children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: BlogPost,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      final data = snapshot.requireData;
                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          var ele = data.docs[index]['tags'];
                          ele.forEach((i) {
                            print(i);
                            tags.add(i);
                          });

                          // tags = tags.replaceAll("[", '');
                          // tags = tags.replaceAll("]", '');
                          // tags = tags.split(",");
                          // List<String> strings = List<String>.from(tags);
                          // print(strings);
                          return Container();
                          // return ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20),
                          //       ),
                          //       primary: Colors.white,
                          //       onPrimary: const Color.fromARGB(255, 80, 80, 80),
                          //     ),
                          //     onPressed: () {},
                          //     child: Column(children: [
                          //       tags.forEach((i) {
                          //         print(i);
                          //         Text(
                          //           i,
                          //           style: const TextStyle(color: Colors.black),
                          //         );
                          //       })
                          //     ]));
                        },
                      );
                    },
                  ),
                ]))));
  }
}

class DisplayCatagory extends StatelessWidget {
  final List<String> names = <String>[
    'Manish',
    'Jitender',
    'Pankaj',
    'Aarti',
    'Nighat',
    'Mohit',
    'Ruchika',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: names.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                margin: EdgeInsets.all(2),
                color: Colors.green,
                child: Center(
                    child: Text(
                  '${names[index]}',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                )),
              );
            }));
  }
}
