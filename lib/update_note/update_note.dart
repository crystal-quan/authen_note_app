// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:authen_note_app/app/app.dart';
import 'package:authen_note_app/home/view/home_page.dart';
import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/update_note/bloc/update_bloc.dart';
import 'package:authen_note_app/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateNotePage extends StatelessWidget {
  String? title;
  String? content;
  String id;
  UpdateNotePage({super.key, this.content, required this.id, this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateBloc(),
      child: UpdateNoteView(content: content, id: id, title: title),
    );
  }
}

class UpdateNoteView extends StatefulWidget {
  String? title;
  String? content;
  String id;
  UpdateNoteView({super.key, this.content, required this.id, this.title});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
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
                    onTap: () {
                      _dialogBuilder(context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(
                    fontSize: 40, decoration: TextDecoration.none),
                cursorHeight: 48,
                controller: TextEditingController(text: widget.title),
                onChanged: (value) {
                  context.read<UpdateBloc>().add(EditTitle(value));
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle:
                        TextStyle(color: Color(0xff9A9A9A), fontSize: 48)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: TextEditingController(text: widget.content),
                maxLines: 18,
                style: const TextStyle(
                    fontSize: 25, decoration: TextDecoration.none),
                cursorHeight: 25,
                onChanged: (value) {
                  context.read<UpdateBloc>().add(EditContent(value));
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
                textStyle: const TextStyle(fontSize: 40, color: Colors.green),
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
            // title: SingleChildScrollView(
            //   child: Image.asset('assets/images/ic_info.png'),
            // ),
          );
        });
    if (result == true) {
      FocusScope.of(context).unfocus();
      context.read<UpdateBloc>().add(ClickUpdate(id: widget.id));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BuildFirstScreen(),
          ));
    }
  }
}
