import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:note_supabase/app/data/models/note.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  final Note note = Get.arguments; 
  
  @override
  Widget build(BuildContext context) {
    controller.titleC.text = note.title;
    controller.descC.text = note.desc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EditNoteView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.titleC,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.descC,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Desc",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
                onPressed: () {
                  if(controller.isLoading.isFalse){
                    controller.editnote(note.id);
                  }
                }, 
                child: Text(controller.isLoading.isFalse ? "Edit Note" : "Loading"),
              )
            )
          ],
        ),
    );
  }
}
