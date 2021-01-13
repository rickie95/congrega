import 'package:formz/formz.dart';

enum PasswordValidationError { empty, short }

class PasswordFormInput extends FormzInput<String, PasswordValidationError> {
  const PasswordFormInput.pure() : super.pure('');
  const PasswordFormInput.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    if(value == null || value.isEmpty)
      return PasswordValidationError.empty;

    if(value.length < 8)
      return PasswordValidationError.short;

    return null;
  }
}
