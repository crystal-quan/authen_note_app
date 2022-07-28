import 'package:authen_note_app/google_login_page/bloc/google_login_bloc.dart';

import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../edit_page/editor_page.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});
  static Page googleLogin() =>
      const MaterialPage<void>(child: GoogleLoginScreen());

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      floatingActionButton: CustomFloatingActionButtton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditorPage()));
      }),
      body: Stack(children: [
        Center(
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
        )),
        Positioned(
          top: 40,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                BlocProvider(
                  create: (_) => GoogleLoginBloc(
                      authenticationRepository: AuthenticationRepository(
                          googleSignIn: GoogleSignIn())),
                  child: BlocBuilder<GoogleLoginBloc, GoogleLoginState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                            child: InkWell(
                          child: Image.asset(
                              'assets/images/ic_google_login.png',
                              fit: BoxFit.cover),
                          onTap: () => context
                              .read<GoogleLoginBloc>()
                              .add(LoginWithGoogle()),
                        )),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
