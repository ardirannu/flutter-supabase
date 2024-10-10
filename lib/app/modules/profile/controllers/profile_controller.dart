import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_supabase/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client; //initial client
  
  void logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> getProfile() async {
    final response = await client
      .from("users")
      .select()
      .eq("uid", client.auth.currentUser!.id)
      .single();

    print(response);
    nameC.text = response["name"];
    emailC.text = response["email"];
  }

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

  void updateProfile() async {
    isLoading.value = true;
    if(nameC.text.isNotEmpty && passwordC.text.isNotEmpty && passwordC.text.length >= 6){
      try {
          await client.from("users").update({
            "name": nameC.text
          }).match({
            "uid": client.auth.currentUser!.id,
          });
        
          final response = await client.auth.updateUser(
            UserAttributes(
              password: passwordC.text,
            ),
          );
          
          if (response.user != null) {
            // Handle error
            print('Error updating profile');
          } else {
            // Success
            print('Profile updated successfully');
          }
        } catch (e) {
          print('Exception updating profile: $e');
        } finally {
          isLoading.value = false;
          Get.back();
        }
    }else{
      Get.snackbar("Eror", "Nama & Password tidak boleh kosong!");
    }
  }
}

