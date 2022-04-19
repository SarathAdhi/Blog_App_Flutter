import 'package:blog_app/screens/home.dart';
import 'package:blog_app/storage_firebase/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CreateBlog());
}

class CreateBlog extends StatelessWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCreateBlogPage(),
    );
  }
}

class MyCreateBlogPage extends StatefulWidget {
  const MyCreateBlogPage({Key? key}) : super(key: key);

  @override
  State<MyCreateBlogPage> createState() => _MyCreateBlogPageState();
}

class _MyCreateBlogPageState extends State<MyCreateBlogPage> {
  var title = '';
  var content = '';
  String tags = '';
  var fileName = '';
  var path = '';
  @override
  Widget build(BuildContext context) {
    CollectionReference BlogPost =
        FirebaseFirestore.instance.collection('BlogPost');
    final Storage storage = Storage();
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Blog-App'),
        // ),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        body: Center(
            child: SingleChildScrollView(
                child: SizedBox(
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                          child: Column(children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.title),
                                labelText: "Enter your title here"),
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            maxLines: 8,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.text_format),
                                labelText: "Enter your content here"),
                            onChanged: (value) {
                              content = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.tag_sharp),
                                labelText: "Enter tags seperated by comma"),
                            onChanged: (value) {
                              tags = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpeg', 'jpg'],
                            );
                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No file is selected")));
                              return;
                            }
                            var unixTime =
                                DateTime.now().toUtc().millisecondsSinceEpoch;

                            path = result.files.single.path!;
                            final fileN = result.files.single.name;
                            fileName = '$unixTime$fileN';
                          },
                          icon: const Icon(
                            Icons.upload,
                            size: 30,
                          ),
                          label: const Text('Upload Image'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          onPressed: () {
                            if (title == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Enter the title")));
                            } else if (content == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Enter some content")));
                            } else if (path == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Upload image")));
                            }
                            if (title != '' &&
                                content != '' &&
                                tags != '' &&
                                path != '') {
                              final splittedTags =
                                  tags.replaceAll(" ", "").split(',');
                              // final get = splittedTags.contains("day");
                              BlogPost.add({
                                'title': title,
                                'content': content,
                                'image': fileName,
                                'tags': splittedTags,
                              })
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Posted the Blog Successfully"))))
                                  .catchError((error) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("!Error: $error"))));

                              storage
                                  .uploadFile(path, fileName)
                                  .then((value) => print("uploaded"));
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const Home()),
                              // );
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('POST'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.send,
                                size: 25.0,
                              ),
                            ],
                          ),
                        )
                      ])),
                    )))));
  }
}
