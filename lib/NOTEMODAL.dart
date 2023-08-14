import 'package:database_sqfliite/AppDatabase.dart';

class NoteModel{
  int? note_id;
  String title;
  String desc;

  NoteModel({this.note_id, required this.title,required this.desc});

  factory NoteModel.fromMap(Map<String,dynamic> map){
      return NoteModel(
        note_id: map[AppDataBase.NOTE_ID],
        title:map[AppDataBase.COLUMN_TITLE],
        desc: map[AppDataBase.COLUMN_DESC]
      );
  }

  Map<String,dynamic> toMAp(){
    return {
      AppDataBase.NOTE_ID:note_id,
      AppDataBase.COLUMN_TITLE:title,
      AppDataBase.COLUMN_DESC:desc
    };
  }

}
