import 'package:flutter/material.dart';

const InputDecoration kimputTextdecoration= InputDecoration(
  hintText: "User ID",
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff080D2E), width: 5.0),
      borderRadius: BorderRadius.all(Radius.circular(20))
  ),
  disabledBorder:OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff080D2E), width: 5.0),
      borderRadius: BorderRadius.all(Radius.circular(20))),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff080D2E), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20))),
);