import 'package:blog_app/storage_firebase/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stream<QuerySnapshot> BlogPost =
      FirebaseFirestore.instance.collection('BlogPost').snapshots();
  final Storage storage = Storage();
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
              child: StreamBuilder<QuerySnapshot>(
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
                      var title = '${data.docs[index]['title']}';
                      title = title.toUpperCase();

                      var content = '${data.docs[index]['content']}';
                      if (content.length > 30) {
                        content = content.substring(0, 150);
                        content = '$content...';
                      }
                      var image = '${data.docs[index]['image']}';

                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                primary: Colors.white,
                                onPrimary:
                                    const Color.fromARGB(255, 80, 80, 80),
                              ),
                              // elevation: 0,
                              // color: const Color.fromARGB(255, 0, 255, 247),
                              onPressed: () {
                                // print(title);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DisplayBlog(passedData: image),
                                    // settings: RouteSettings(
                                    //   arguments: {'title': title},
                                    // ),
                                  ),
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    FutureBuilder(
                                        future: storage.downloadURL(
                                            '${data.docs[index]['image']}'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    snapshot.data!,
                                                    width:
                                                        (MediaQuery.of(context)
                                                            .size
                                                            .width),
                                                    // height: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ));
                                          }
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              !snapshot.hasData) {
                                            return const CircularProgressIndicator();
                                          }
                                          return Container();
                                        }),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      content,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ]))));
                    },
                  );
                },
              )),
        ));
  }
}

// Full blog post read

// ignore: must_be_immutable
class DisplayBlog extends StatelessWidget {
  final String passedData;
  final Storage storage = Storage();

  DisplayBlog({Key? key, required this.passedData}) : super(key: key);
  // ignore: non_constant_identifier_names
  final Stream<QuerySnapshot> BlogPost =
      FirebaseFirestore.instance.collection('BlogPost').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            )
          },
        ),
        centerTitle: true,
        title: Text("Blog Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
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
                var image = '${data.docs[index]['image']}';
                var title = '';
                var content = '';
                if (image == passedData) {
                  title = '${data.docs[index]['title']}';
                  content = '${data.docs[index]['content']}';
                } else {
                  return Container();
                }
                return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder(
                                  future: storage.downloadURL(
                                      '${data.docs[index]['image']}'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          snapshot.data!,
                                          // width: 300,
                                          // height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Container();
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                content,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]))));
              },
            );
          },
        ),
      ),
    );
  }
}
