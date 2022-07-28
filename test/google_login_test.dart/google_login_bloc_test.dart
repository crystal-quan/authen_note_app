import 'package:authen_note_app/google_login_page/bloc/google_login_bloc.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserCredential extends Mock implements auth.UserCredential {}

class MockGoogleLoginEvent extends Mock implements GoogleLoginEvent {}

class MockEmitter<GoogleLoginState> extends Mock
    implements Emitter<GoogleLoginState> {}

void main() {
  late MockAuthenticationRepository authenticationRepository;
  late GoogleLoginBloc googleLoginBloc;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential userCredential;
  late MockUser mockUser;

  setUp(
    () async {
      mockUser = MockUser(email: 'test@gmail.com', uid: 'autoID');
      userCredential = MockUserCredential();
      mockFirebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

      authenticationRepository = MockAuthenticationRepository();

      when(() => userCredential.user?.email).thenReturn('test@gmail.com');
      when(() => userCredential.user?.uid).thenReturn('autoID');
      when(() => authenticationRepository.logInWithGoogle())
          .thenAnswer((invocation) async => Future.value(userCredential));
    },
  );

  test(
    'initial state is correct',
    () {
      googleLoginBloc =
          GoogleLoginBloc(authenticationRepository: authenticationRepository);
      expect(googleLoginBloc.state, GoogleLoginState());
    },
  );

  blocTest<GoogleLoginBloc, GoogleLoginState>(
    'emit status Failure when AuthenFirebase error',
    setUp: () {
      googleLoginBloc =
          GoogleLoginBloc(authenticationRepository: authenticationRepository);
      when(() => authenticationRepository.logInWithGoogle())
          .thenThrow(LogInWithGoogleFailure());
    },
    build: () => googleLoginBloc,
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => <GoogleLoginState>[
      GoogleLoginState(status: FormzStatus.submissionInProgress),
      GoogleLoginState(status: FormzStatus.submissionFailure)
    ],
  );

  // blocTest<GoogleLoginBloc, GoogleLoginState>(
  //   'calls Authen.loginWithgoogle when bloc.LoginWithGoogle',
  //   setUp: () {
  //     googleLoginBloc =
  //         GoogleLoginBloc(authenticationRepository: authenticationRepository);
  //   },
  //   build: () => googleLoginBloc,
  //   act: (bloc) => googleLoginBloc.add(LoginWithGoogle()),
  //   verify: (_) {
  //     verify(() => authenticationRepository.logInWithGoogle()).called(1);
  //   },
  // );

  blocTest<GoogleLoginBloc, GoogleLoginState>(
    'emit status Success with authenRypository',
    setUp: () {
      googleLoginBloc =
          GoogleLoginBloc(authenticationRepository: authenticationRepository);
      // when(() => authenticationRepository.logInWithGoogle()).th
    },
    build: () => googleLoginBloc,
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => <GoogleLoginState>[
      GoogleLoginState(status: FormzStatus.submissionInProgress),
      GoogleLoginState(status: FormzStatus.submissionSuccess)
    ],
  );

  blocTest<GoogleLoginBloc, GoogleLoginState>(
    'emit status when AuthenFirebase ',
    setUp: () {
      googleLoginBloc =
          GoogleLoginBloc(authenticationRepository: authenticationRepository);
      when(() => authenticationRepository.logInWithGoogle()).thenThrow(Error());
    },
    build: () => googleLoginBloc,
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => <GoogleLoginState>[
      GoogleLoginState(status: FormzStatus.submissionInProgress),
      GoogleLoginState(status: FormzStatus.submissionFailure)
    ],
  );
}
