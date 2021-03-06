// import 'package:formz/formz.dart';

// /// Validation errors for the [Email] [FormzInput].
// enum PhoneValidationError {
//   /// Generic invalid error.
//   invalid
// }

// /// {@template email}
// /// Form input for an email input.
// /// {@endtemplate}
// class Phone extends FormzInput<String, PhoneValidationError> {
//   /// {@macro email}
//   const Phone.pure() : super.pure('');

//   /// {@macro email}
//   const Phone.dirty([String value = '']) : super.dirty(value);

//   static final RegExp _phoneRegExp = RegExp(
//     r'^[(+84)]+[a-Z0-9-]*$',
//   );

//   @override
//   PhoneValidationError? validator(String? value) {
//     return _phoneRegExp.hasMatch(value ?? '')
//         ? null
//         : PhoneValidationError.invalid;
//   }
// }
