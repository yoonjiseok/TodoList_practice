import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist_practice/dto/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_complete_guide/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  await Firebase.initializeApp(

  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //List<Todo> lst = [];
  var txtTodo = TextEditingController();

  @override
  void initState() {
    super.initState();
    //lst.add(Todo('청소'));
    //lst.add(Todo('공부'));
  }

  @override
  void dispose(){
    txtTodo.dispose();
    // TODO : implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("할일 관리")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txtTodo,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      print("71 : ${txtTodo.text}");
                      addTodo(txtTodo.text);


                      txtTodo.text = "";


                      setState(() {});
                    },
                    child: Text('저장'))
              ],
            ),
            SizedBox(height: 20),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("todo").snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  var docs = snapshot.data!.docs;
                  print("92 에러:${docs}");




                  return  Expanded(
                      child : ListView(
                      children: buildTodoList(docs),
                    ),
                  );
                }

              ),

          ],
        ),
      ),
    );
  }


  List<Widget> buildTodoList(lst) {
    for (var item in lst){
      print("117:${item['title']}");

    }

    return lst.map<Widget>((e) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: () {
                  changeDone(e);
                  setState(() {});
                },
                child: Row(
                  children: [

                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child: Text(
                        e['title'],
                        style: e['isDone'] == true
                            ? TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            fontStyle: FontStyle.italic)
                            : null,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                        "${e['createDate'].toString().substring(0,4)}."
                            "${e['createDate'].toString().substring(4,6)}."
                            "${e['createDate'].toString().substring(6)}"
                    )
                  ],
                )
            ),

          ),
          IconButton(
            onPressed: () {

              deleteTodo(e);
              setState(() {});
            },
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          )
        ],

      );
    }).toList();
    }


//Document snapshot
  changeDone(DocumentSnapshot e) {
    FirebaseFirestore.instance.collection('todo').doc(e.id).update({'isDone' : !e['isDone']});

  }

  addTodo(String title) {

        FirebaseFirestore.
          instance.
            collection('todo').
              add({'title' : title, 'isDone' : false , 'createDate' : getNow()});

        // CollectionReference users = FirebaseFirestore.instance.collection('todo');
        // users.add({'title' : title, 'isDone' : false, 'createDate' : getNow()});

  }

  void deleteTodo(DocumentSnapshot item) {
      FirebaseFirestore.instance.collection('todo').doc(item.id).delete();

  }

  getNow() {
    String strRet = "";
    strRet = DateTime.now().year.toString();
    strRet += DateTime.now().month.toString().padLeft(2,'0');
    strRet += DateTime.now().day.toString().padLeft(2,'0');
    return strRet;
  }


}
