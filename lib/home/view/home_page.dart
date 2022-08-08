// ignore_for_file: prefer_is_empty

import 'package:authen_note_app/edit_page/editor_page.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:authen_note_app/widget/custom_button.dart';
import 'package:authen_note_app/widget/loading_screen.dart';

import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/update_note/update_note.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../app/app.dart';
import '../widgets/avatar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeBloc homeBloc = HomeBloc(
    noteRepository: NoteRepository(
      firestore: FirebaseFirestore.instance,
      box: Hive.box<Note>('notes'),
    ),
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    widget.homeBloc.add(CheckLogin());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: backgroundColor2,
      floatingActionButton: CustomFloatingActionButtton(onPressed: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditorView(
                      list: widget.homeBloc.state.listNotes ?? [],
                      homeBloc: widget.homeBloc,
                    )));
      }),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<HomeBloc, HomeState>(
                  bloc: widget.homeBloc,
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  buildWhen: (previous, current) =>
                      previous.user.name != current.user.name,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notes',
                          style: TextStyle(fontSize: 40),
                        ),
                        (state.user.name == null)
                            ? InkWell(
                                child: Image.asset(
                                  'assets/images/ic_google_login.png',
                                  width: 50,
                                  height: 50,
                                ),
                                onTap: () {
                                  widget.homeBloc.add(LoginWithGoogle());
                                },
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Avatar(photo: state.user.photo)),
                                  IconButton(
                                    key:
                                        const Key('homePage_logout_iconButton'),
                                    icon:
                                        const Icon(Icons.exit_to_app, size: 30),
                                    onPressed: () {
                                      widget.homeBloc.add(AppLogoutRequested());
                                    },
                                  )
                                ],
                              ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  bloc: widget.homeBloc,
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    if (state.listNotes?.length != null) {
                      if (state.listNotes!.length == 0) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height:
                                (MediaQuery.of(context).size.height < 800.00)
                                    ? 350
                                    : MediaQuery.of(context).size.height * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_center_bg.png',
                                ),
                                const Text(
                                  'Create your first note !',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ));
                      } else {
                        return SizedBox(
                          height: (MediaQuery.of(context).size.height < 800.00)
                              ? 350
                              : MediaQuery.of(context).size.height * 0.74,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 20,
                            ),
                            padding: const EdgeInsets.all(20),
                            addAutomaticKeepAlives: true,
                            itemCount: state.listNotes!.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      // An action can be bigger than the others.

                                      onPressed: (context) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateNoteView(
                                                        timeCreate: state
                                                            .listNotes?[index]
                                                            .timeCreate,
                                                        homeBloc:
                                                            widget.homeBloc,
                                                        content: state
                                                                .listNotes?[
                                                                    index]
                                                                .content ??
                                                            '',
                                                        id: state
                                                                .listNotes?[
                                                                    index]
                                                                .id ??
                                                            '',
                                                        title: state
                                                                .listNotes?[
                                                                    index]
                                                                .title ??
                                                            '')));
                                      },
                                      backgroundColor: const Color(0xFF7BC043),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        widget.homeBloc.add(Delete(
                                            id: state.listNotes![index].id,
                                            content:
                                                state.listNotes![index].content,
                                            title:
                                                state.listNotes![index].title,
                                            timeCreate: state
                                                .listNotes![index].timeCreate));
                                      },
                                      backgroundColor: const Color(0xFF0392CF),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: titleColor[index % 6],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: const EdgeInsets.all(25),
                                  child: Text(
                                    '${state.listNotes?[index].title}',
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return LoadingScreen(
                        height: (MediaQuery.of(context).size.height < 900.00)
                            ? 350
                            : MediaQuery.of(context).size.height * 0.5,
                      );
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
