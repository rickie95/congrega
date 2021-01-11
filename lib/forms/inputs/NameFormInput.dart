import 'package:formz/formz.dart';

enum NameValidationError { empty }

class NameFormInput extends FormzInput<String, NameValidationError> {
  const NameFormInput.pure() : super.pure('');
  const NameFormInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError validator(String value) {
    if(value != null && value.isNotEmpty)
      return null;

    return NameValidationError.empty;
  }
}
