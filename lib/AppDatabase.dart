// sabse pehle class banaenge database naam ki
import 'dart:io';

import 'package:database_sqfliite/NOTEMODAL.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase{
  AppDataBase._();//yeh class ke constructor ko private bana dia hn ab es class ka kahi bhi obect create nhi hoga agar esa hua toh maano 4 log databse access kr rhe hn
  // toh voh apne hisab se data add or remove krenge esa na ho isliye yeh kia hn
  static final AppDataBase db=AppDataBase._(); // es constructor ke refrence ke lie static variable banay ah n aur ese final bhi banaya hn taaki
//koi aur ese change na kar pae

/*es upar do line matlab hn ki humne es class ka private obejct bana dia taaki koi baar baar object na banae taaki different loglog pe different databse na bane
* aur fir next line me use ek variable me daal dia taaki m ain class me usse access kr pae*/

  static final TABLE_name="note";
  static final NOTE_ID="note_id";
  static final COLUMN_TITLE="title";
  static final COLUMN_DESC="desc";
Database? _database;

  Future<Database> getDB() async{
  if(_database!=null){
    return _database!;
  }
  else {
    return await initDB();
  }
}
 Future<Database> initDB() async{
  Directory documentsPath= await getApplicationDocumentsDirectory();
  var dbPAth=join(documentsPath.path,"notesDb.db");
   return openDatabase(dbPAth,
  version: 1,
      onCreate: (db,version){
 // now here we will create tables
        db.execute("Create table $TABLE_name ( $NOTE_ID integer primary key autoincrement, $COLUMN_TITLE text, $COLUMN_DESC text )" );

  }
  );
}
Future<bool> Addnote(NoteModel note) async{
    var db= await getDB();
      var rowsEffected= await db.insert(TABLE_name, note.toMAp());
      if(rowsEffected>0){
        return true;
      }
      else{
        return false;
      }

}

Future<List<NoteModel>> fetchNote()async{
    var db= await getDB();
    List<Map<String, Object?>> notes= await db.query(TABLE_name);

    List<NoteModel> listNotes=[];
    for(Map<String, Object?> note in notes){
      NoteModel model=NoteModel.fromMap(note);
      listNotes.add(model);
    }
    return listNotes;
}

Future<bool> updateNote(NoteModel note)async{
  var db= await getDB();
  var count = await db.update(TABLE_name, note.toMAp(), where: "$NOTE_ID= ${note.note_id}");
  return count>0;

}
Future<bool> deleteNote(int id)async{
  var db= await getDB();
  var count= await db.delete(TABLE_name,where: "$NOTE_ID=?",whereArgs: ["$id"]);

  return count>0;
  }

}