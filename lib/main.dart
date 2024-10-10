import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //initial supabase
  Supabase supabase = await Supabase.initialize(
    url: "https://eqfxbmzqqylzwkqpozwt.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxZnhibXpxcXlsendrcXBvend0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM0NjE4NDIsImV4cCI6MjAzOTAzNzg0Mn0.NOPMcANyE1BaLLOBnshr5385PhE2qwS-uO0JTdUF2wk"
  );

  runApp(
    GetMaterialApp(
      title: "Supanote",
      initialRoute: supabase.client.auth.currentUser == null ? Routes.LOGIN : Routes.HOME, //check user session
      getPages: AppPages.routes,
    ),
  );
}
