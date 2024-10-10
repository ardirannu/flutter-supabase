import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:note_supabase/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController(text: 'rannuardianto55@gmail.com');
  TextEditingController passwordC = TextEditingController(text: '123456');

  SupabaseClient client = Supabase.instance.client; //initial client

  void login() async {
    //form validation
    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
      isLoading.value = true;
      try {
        final AuthResponse response = await client.auth.signInWithPassword(
          email: emailC.text, 
          password: passwordC.text
        );

        if (response.user != null) {
          isLoading.value = false;
          print(response.session);
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
