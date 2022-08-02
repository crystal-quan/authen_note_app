import 'package:authen_note_app/google_login_page/google_login_screen.dart';
import 'package:flutter/widgets.dart';

import '../../home/view/home_page.dart';

import '../bloc/app_bloc.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [GoogleLoginPage.googleLogin()];
  }
}
