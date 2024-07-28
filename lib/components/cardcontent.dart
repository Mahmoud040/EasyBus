import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class contentcolnofunc extends StatelessWidget {
  contentcolnofunc({this.Etime, @required this.label,this.label1,this.label2});

  final int Etime;
  final String label;
  final String label1;
  final String label2;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),

      ],
    );
  }
}
