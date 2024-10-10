import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:note_supabase/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  SupabaseClient client = Supabase.instance.client; //initial client

  void editnote(int noteId) async {
    isLoading.value = true;
    if(titleC.text.isNotEmpty && descC.text.isNotEmpty){
      try {
        List<dynamic> user = await client
        .from("users")
        .select("id")
        .match({
          "uid": client.auth.currentUser!.id, // compare UID
        });

        // Get id from first user
        int userId = user.first["id"];
        await client.from("notes").update({
          "user_id": userId,
          "title": titleC.text,
          "desc": descC.text,
        }).match({"id": noteId});

        isLoading.value = false;
      } catch (e) {
        print('Exception updating profile: $e');
      } finally {
        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
      }
    } else{
      isLoading.value = false;
      Get.snackbar("Terjadi kesalahan!", "Title & Desc belum diisi!");
    }
  }
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
