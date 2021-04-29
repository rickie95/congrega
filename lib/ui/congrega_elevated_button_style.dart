import 'package:flutter/material.dart';

final ButtonStyle elevatedDangerButtonStyle = ButtonStyle(backgroundColor: dangerButtonColorState);

final MaterialStateProperty<Color> dangerButtonColorState = MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed))
      return Colors.red.withOpacity(0.5);
    return Colors.red; // Use the component's default.
  },
);

final ButtonStyle elevatedActionButtonStyle = ButtonStyle(backgroundColor: actionButtonColorState);

final MaterialStateProperty<Color> actionButtonColorState = MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed))
        return Colors.lightBlue.withOpacity(0.5);
      return Colors.lightBlue; // Use the component's default.
    },
);