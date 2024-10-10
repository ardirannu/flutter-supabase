import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_supabase/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNoteController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  SupabaseClient client = Supabase.instance.client; //initial client

  void addnote() async {
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
        int id = user.first["id"];
        await client.from("notes").insert({
          "user_id": id,
          "title": titleC.text,
          "desc": descC.text,
        });

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
