import 'package:authen_note_app/app/app.dart';
import 'package:authen_note_app/google_login_page/bloc/google_login_bloc.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/home/home.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
import 'package:authen_note_app/repository/note_repository.dart';

import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/widget/custom_button.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
// import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../edit_page/editor_page.dart';
import '../update_note/update_note.dart';
import '../widget/loading_screen.dart';

class GoogleLoginPage extends StatelessWidget {
  static Page googleLogin() =>
      const MaterialPage<void>(child: GoogleLoginPage());

  const GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleLoginBloc(
        authenticationRepository: GoogleAuthenRepository(
            firebaseAuth: auth.FirebaseAuth.instance,
            googleSignIn: GoogleSignIn()),
        noteRepo: NoteRepository(
          firestore: FirebaseFirestore.instance,
          firebaseAuth: auth.FirebaseAuth.instance,
          box: Hive.box<Note>('notes'),
        ),
      ),
      child: GoogleLoginScreen(),
    );
  }
}

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  initState() {
    // bool checkInternet = await InternetConnectionChecker().hasConnection;
    super.initState();

    // Add listeners to this class
    context.read<GoogleLoginBloc>().add(GetNoteOffline());
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeBloc(
      noteRepository: NoteRepository(
        firestore: FirebaseFirestore.instance,
        firebaseAuth: auth.FirebaseAuth.instance,
        box: Hive.box<Note>('notes'),
      ),
    );
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Notes',
              style: TextStyle(fontSize: 35),
            ),
            actions: [
              CustomButton(
                imageAssets: 'ic_google_login.png',
                onTap: () {
                  context.read<GoogleLoginBloc>().add(LoginWithGoogle());
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BuildFirstScreen()));
                },
              )
            ],
            backgroundColor: backgroundColor2),
        backgroundColor: backgroundColor2,
        floatingActionButton: CustomFloatingActionButtton(onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditorPage()));
        }),
        body: BlocBuilder<GoogleLoginBloc, GoogleLoginState>(
          builder: (context, state) {
            if (state.noteOffline?.length != null) {
              if (state.noteOffline?.length == 0) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height < 800.00)
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
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    padding: const EdgeInsets.all(20),
                    addAutomaticKeepAlives: true,
                    itemCount: state.noteOffline!.length,
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
                                        builder: (context) => UpdateNotePage(
                                            content: state
                                                .noteOffline![index]?.content,
                                            timeCreate: state
                                                .noteOffline![index]
                                                ?.timeCreate,
                                            id: state.noteOffline![index]!.id,
                                            title: state
                                                .noteOffline![index]?.title)));
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                homeBloc.add(Delete(
                                    timeCreate:
                                        state.noteOffline![index]?.timeCreate,
                                    title: state.noteOffline![index]?.title,
                                    content: state.noteOffline![index]?.content,
                                    id: state.noteOffline![index]!.id
                                        .toString()));
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const GoogleLoginPage();
                                }));
                              },
                              backgroundColor: const Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ],
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: titleColor[index % 6],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(25),
                          child: Text(
                            '${state.noteOffline![index]?.title}',
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
        ));
  }
}
