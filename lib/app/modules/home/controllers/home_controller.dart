import 'package:get/get.dart';
import 'package:note_supabase/app/data/models/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  RxList allNotes = List<Note>.empty().obs;
  SupabaseClient client = Supabase.instance.client; //initial client

  Future<void> getAllNotes() async {
    List<dynamic> user = await client
      .from("users")
      .select("id")
      .match({
        "uid": client.auth.currentUser!.id, // compare UID
      });

    // Get id from first user
    int id = user.first["id"];
    var notesResponse = await client.from("notes").select().match({
      "user_id": id
    });

    allNotes.assignAll(
      //map satu persatu list map notesResponse, lalu masukan ke model 
      notesResponse.map<Note>((note) => Note.fromJson(note)).toList()
    );
    allNotes.refresh();
  }

  void deleteNote(int id) async {
    await client.from("notes").delete().match({ "id": id});
    await getAllNotes();
  }
}
