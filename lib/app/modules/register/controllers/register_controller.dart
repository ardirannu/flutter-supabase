import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:note_supabase/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController(text: 'ardi');
  TextEditingController emailC = TextEditingController(text: 'rannuardianto55@gmail.com');
  TextEditingController passwordC = TextEditingController(text: '123456');

  SupabaseClient client = Supabase.instance.client; //initial client

  void signUp() async {
    //form validation
    if(nameC.text.isNotEmpty && emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
      isLoading.value = true;
      try {
        final AuthResponse response = await client.auth.signUp(
          email: emailC.text, 
          password: passwordC.text
        );

        if (response.user != null) {
          isLoading.value = false;
          // print(response.session);
          // print(response.user);

          //insert data user to table users
          await client.from("users").insert({
            "uid": response.user!.id,
            "name": nameC.text,
            "email": emailC.text,
            "created_at": DateTime.now().toIso8601String(),
          });

          Get.offAllNamed(Routes.HOME);
        }
      } catch (e) {
        isLoading.value = false;

        if (e is AuthException) {
          Get.snackbar("Terjadi kesalahan!", "${e.message}");
        } else {
          print('Unexpected error: $e');
        }
      }
    }else{
      isLoading.value = false;
      Get.snackbar("Terjadi kesalahan!", "Email & Password belum diisi!");
    }
  }
}
