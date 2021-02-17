import 'package:conversor/conversor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ConversorScreen(),
    theme: _themeData));

ThemeData get _themeData {
  return ThemeData(
      hintColor: Color(0xFF7159C1),
      primaryColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF7159C1))),
        hintStyle: TextStyle(color: Color(0xFF7159C1)),
      ));
}
