import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:authen_note_app/google_login_page/google_login_screen.dart';
import 'package:authen_note_app/home/view/home_page.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
// import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';
import '../routes/routes.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final GoogleAuthenRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          ggAuthenticationRepository: authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      highContrastTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AnimatedSplashScreen(
          duration: 0,
          splash: Icons.note_add,
          nextScreen: const HomePage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.blue),
    );
  }
}

// class BuildFirstScreen extends StatefulWidget {
//   const BuildFirstScreen({super.key});

//   @override
//   State<BuildFirstScreen> createState() => _BuildFirstScreenState();
// }

// class _BuildFirstScreenState extends State<BuildFirstScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     context.read<AppBloc>().add(CheckLogin());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppBloc, AppState>(
//         buildWhen: (previous, current) => previous.status != previous.status,
//         builder: (context, state) {
//           if (state.status == AppStatus.authenticated) {
//             return const HomePage();
//           } else {
//             return const GoogleLoginPage();
//           }
//         });
//   }
// }
