import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:note_supabase/app/data/models/note.dart';
import 'package:note_supabase/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.PROFILE),
              icon: Icon(Icons.person))
        ],
      ),
      body: FutureBuilder(
          future: controller.getAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            
            return Obx(() => ListView.builder(
              itemCount: controller.allNotes.length,
              itemBuilder: (context, index) {
                Note note = controller.allNotes[index];
                return ListTile(
                  onTap: () => Get.toNamed(Routes.EDIT_NOTE, arguments: note),
                  leading: CircleAvatar(
                    child: Text("${note.id}"),
                  ),
                  title: Text("${note.title}"),
                  subtitle: Text("${note.desc}"),
                  trailing: IconButton(
                    onPressed: () {
                      controller.deleteNote(note.id);
                    }, 
                    icon: Icon(Icons.delete)
                  ),
                );
              },
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_NOTE),
        child: Icon(Icons.add),
      ),
    );
  }
}
