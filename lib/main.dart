import 'package:blog_app/screens/categories.dart';
import 'package:blog_app/screens/create.dart';
import 'package:blog_app/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppNavBar(),
    );
  }
}

class MyAppNavBar extends StatefulWidget {
  const MyAppNavBar({Key? key}) : super(key: key);

  @override
  State<MyAppNavBar> createState() => _MyAppNavBarState();
}

class Index {
  static int currentIndex = 0;
}

class _MyAppNavBarState extends State<MyAppNavBar> {
  final Stream<QuerySnapshot> blogTitle =
      FirebaseFirestore.instance.collection('BlogPost').snapshots();

  final screens = [
    const Home(),
    const Categories(),
    const CreateBlog(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[Index.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => setState(() => Index.currentIndex = index),
          currentIndex: Index.currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
          selectedItemColor: const Color.fromARGB(255, 2, 154, 255),
          backgroundColor: const Color.fromARGB(254, 44, 44, 44),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Create',
            ),
          ],
        ));
  }
}
