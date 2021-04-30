import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class InheritableData extends InheritedWidget {

  final bool darkmode;

  InheritableData({this.darkmode, Widget myChild})
      : super(child: myChild);

  static InheritableData of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritableData) as InheritableData;

  bool updateShouldNotify(InheritableData oldWidget) =>
      oldWidget.darkmode != darkmode;
}