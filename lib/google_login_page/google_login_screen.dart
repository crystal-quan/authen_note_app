import 'package:authen_note_app/google_login_page/login_cubit.dart';
import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            MaterialPageRoute(builder: (context) => EditorPage()));
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
                  create: (_) =>
                      LoginCubit(context.read<AuthenticationRepository>()),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return Container(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                            child: InkWell(
                          child: Image.asset(
                              'assets/images/ic_google_login.png',
                              fit: BoxFit.cover),
                          onTap: () =>
                              context.read<LoginCubit>().logInWithGoogle(),
                        )),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          top: 40,
          width: MediaQuery.of(context).size.width,
        )
      ]),
    );
  }
}
