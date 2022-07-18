import 'package:authen_note_app/edit_page/editor_page.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/theme/color.dart';
import 'package:authen_note_app/update_note/update_note.dart';
import 'package:authen_note_app/widget/floatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../app/app.dart';
import '../widgets/avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeScreen(),
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
            context, MaterialPageRoute(builder: (context) => const EditorPage()));
      }),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 40),
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 50,
                        height: 50,
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
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.listNotes?.length != current.listNotes?.length,
              builder: (context, state) {
                if (state.listNotes?.isNotEmpty == true) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.74,
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      //physics: ScrollPhysics(),
                      // shrinkWrap: true,

                      itemCount: state.listNotes?.length,
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
                                                  .listNotes![index].content,
                                              id: state.listNotes![index].id,
                                              title: state
                                                  .listNotes![index].title)));
                                },
                                backgroundColor: const Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  context.read<HomeBloc>().add(Delete(
                                      id: state.listNotes![index].id
                                          .toString()));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                                },
                                backgroundColor: const Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,

                            decoration: BoxDecoration(
                                color: titleColor[index % 6],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            // width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${state.listNotes?[index].title}',
                              style:
                                  const TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
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
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
