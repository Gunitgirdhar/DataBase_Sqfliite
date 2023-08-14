import 'package:database_sqfliite/AppDatabase.dart';
import 'package:database_sqfliite/NOTEMODAL.dart';
import 'package:flutter/material.dart';
// in pubspect.yaml
/*sqflite is for storing offline data if our app will be closed data will stay
path provider is used kyunki hume datbase app ke documents section me banana hota h ntoh vha tak ka path humw path provider data hn
path is used for agr path provider pe koi bhi operation lagana hn toh path ka use krenge
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDataBase myDB;
  List<NoteModel> arrNotes=[];
  var titleController=TextEditingController();
  var descController=TextEditingController();
  @override
  void initState() {
    super.initState();
    myDB=AppDataBase.db;
    getNotes();
  }

  void getNotes()async{
    arrNotes= await myDB.fetchNote();
    setState(() {

    });
  }
  void Addnotes(String title,String desc)async {
   bool check=  await myDB.Addnote(NoteModel(title: title, desc: desc));
   if(check){
     arrNotes= await myDB.fetchNote();
     setState(() {

     });
   }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: arrNotes.length,
        itemBuilder: (_, index) {
        return InkWell(
          onTap: (){
            titleController.text= arrNotes[index].title;
            descController.text= arrNotes[index].desc;
            showModalBottomSheet(context: context, builder: (context) {
              return Container(
                height: 500,
                child: Column(
                  children: [
                    TextField(
                      controller:titleController ,
                    ), TextField(
                      controller:descController ,
                    ),
                    ElevatedButton(onPressed: ()async{
                      var title_controller=titleController.text.toString();
                      var desc_controller=descController.text.toString();
                      await myDB.updateNote(NoteModel(title: title_controller, desc: desc_controller,note_id: arrNotes[index].note_id));
                      getNotes();
                     // Addnotes(title_controller, desc_controller);

                    }, child: Text("Save"))
                  ],
                ),
              );
            },);
          },
          child: ListTile(
            title: Text(arrNotes[index].title),
            subtitle: Text(arrNotes[index].desc) ,
            trailing: InkWell(
                onTap: ()async{
                   await myDB.deleteNote(arrNotes[index].note_id!);
                  getNotes();
                },
                child: Icon(Icons.delete)),
          ),
        );
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context, builder: (context) {
            return Container(
              height: 500,
              child: Column(
                children: [
                  TextField(
                    controller:titleController ,
                  ), TextField(
                    controller:descController ,
                  ),
                  ElevatedButton(onPressed: ()async{
                    var title_controller=titleController.text.toString();
                    var desc_controller=descController.text.toString();
                   //await myDB.updateNote(NoteModel(title: title_controller, desc: desc_controller,note_id: arrNotes[index].note_id));
                    Addnotes(title_controller, desc_controller);
                  titleController.clear();
                   descController.clear();
                  }, child: Text("Save"))
                ],
              ),
            );
          },);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

