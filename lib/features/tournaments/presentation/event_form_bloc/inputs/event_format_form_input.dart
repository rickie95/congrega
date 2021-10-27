import 'package:formz/formz.dart';

enum NameValidationError { empty }

class FormatFormInput extends FormzInput<String, NameValidationError> {
  const FormatFormInput.pure() : super.pure('');
  const FormatFormInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String value) {
    if (value.isNotEmpty) return null;

    return NameValidationError.empty;
  }
}
