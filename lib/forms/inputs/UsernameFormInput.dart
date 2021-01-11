import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class UsernameFormInput extends FormzInput<String, UsernameValidationError> {
  const UsernameFormInput.pure() : super.pure('');
  const UsernameFormInput.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : UsernameValidationError.empty;
  }
}
