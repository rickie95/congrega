import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class PasswordFormInput extends FormzInput<String, PasswordValidationError> {
  const PasswordFormInput.pure() : super.pure('');
  const PasswordFormInput.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    if(value != null && value.isNotEmpty && value.length > 7)
      return null;

    return PasswordValidationError.empty;
  }
}
