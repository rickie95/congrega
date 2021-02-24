
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinByCodeDialog extends StatefulWidget {
  const JoinByCodeDialog({
    Key key,
  }) : super(key: key);

  _JoinCodeByDialogState createState() => _JoinCodeByDialogState();
}

class _JoinCodeByDialogState extends State<JoinByCodeDialog> {

  final TextEditingController inputController = TextEditingController();

  @override
  void dispose(){
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join event by code'),
      content: SingleChildScrollView(

        /* TODO: add eventBlocBuilder and return a circular indicator if enrolling,
           use hint/error message to notify user. */
        child: ListBody(
          children: <Widget>[
            Text("Enter the code provided by event's organizer"),
            TextFormField(
              controller: inputController,
              textAlign: TextAlign.center,
              inputFormatters: [UpperCaseTextFormatter()],
              validator: (value) {
                if(value.isEmpty)
                  return 'Please enter a non empty code';

                return null;
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Enter'),
          onPressed: () {

            // TODO: notify eventBloc, send code
            debugPrint(inputController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
