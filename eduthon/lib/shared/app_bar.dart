import 'dart:ui';

import 'package:eduthon/theme/colors.dart';
import 'package:flutter/material.dart';

AppBar appBar(String title) {
  return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 17)),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                  colors: <Color>[mainColor, iconColor]))),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30)),
      ));
}
