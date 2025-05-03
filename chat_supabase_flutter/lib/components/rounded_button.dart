import 'package:flutter/material.dart';

Widget createRoundedButton(Color color, String label, Function pressed) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Material(
      elevation: 5.0,
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: () {
          pressed();
        },
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}