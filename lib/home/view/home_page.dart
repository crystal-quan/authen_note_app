import 'package:authen_note_app/edit_page/editor_page.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app.dart';
import '../widgets/avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    // Add listeners to this class
    context.read<HomeBloc>().add(GetNote());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: backgroundColor2,
      floatingActionButton: CustomFloatingActionButtton(onPressed: () {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage()));
      }),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes',
                  style: TextStyle(fontSize: 40),
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 60,
                        height: 60,
                        child: Avatar(photo: user.photo)),
                    IconButton(
                      key: const Key('homePage_logout_iconButton'),
                      icon: const Icon(Icons.exit_to_app, size: 30),
                      onPressed: () =>
                          context.read<AppBloc>().add(AppLogoutRequested()),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(' Hello', style: textTheme.headline6),
            const SizedBox(height: 4),
            Text(user.name ?? '', style: textTheme.headline5),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<HomeBloc, HomeState>(
              // buildWhen: (previous, current) =>
              //     previous.listNotes != current.listNotes,
              builder: (context, state) {
                if (state.listNotes != null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.listNotes!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: titleColor[index % 6],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '${state.listNotes![index].title}',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ic_center_bg.png'),
                          Text('Create your first note')
                        ]),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
