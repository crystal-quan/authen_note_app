// ignore_for_file: use_build_context_synchronously

import 'package:authen_note_app/app/app.dart';
import 'package:authen_note_app/edit_page/bloc/editor_bloc.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';

import 'package:authen_note_app/home/view/home_page.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditorView extends StatelessWidget {
  final List<Note> list;
  final EditorBloc editorBloc = EditorBloc();
  final HomeBloc homeBloc;
  EditorView({super.key, required this.list, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      imageAssets: 'ic_back.png',
                      onTap: () => Navigator.of(context).pop()),
                  CustomButton(
                    imageAssets: 'ic_save.png',
                    onTap: () async {
                      _dialogBuilder(context);

                      //context.read<EditorBloc>().add(SaveNote());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  editorBloc.add(EditorTitle(value));
                },
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(
                    fontSize: 40, decoration: TextDecoration.none),
                cursorHeight: 48,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Title',
                    hintStyle:
                        TextStyle(color: Color(0xff9A9A9A), fontSize: 48)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 18,
                style: const TextStyle(
                    fontSize: 25, decoration: TextDecoration.none),
                cursorHeight: 25,
                onChanged: (value) {
                  editorBloc.add(EditorContent(value));
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Type something...',
                    hintStyle:
                        TextStyle(color: Color(0xff9A9A9A), fontSize: 25)),
              ),
            ])),
      ),
    );
  }

  void _dialogBuilder(BuildContext context) async {
    final result = await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                actions: [
                  CupertinoDialogAction(
                    textStyle: const TextStyle(fontSize: 40, color: Colors.red),
                    child: const Text('Discard'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  CupertinoDialogAction(
                    textStyle:
                        const TextStyle(fontSize: 40, color: Colors.green),
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
                title: const Text(
                  'Save changes ?',
                  style: TextStyle(fontSize: 30),
                ),
              );
            }) ??
        false;
    if (result) {
      FocusScope.of(context).unfocus();
      homeBloc.add(AddNote(
          content: editorBloc.state.content,
          title: editorBloc.state.title,
          list: list));
      print('quanbv check list- ${list}');
      Navigator.pop(context);
    }
  }
}
