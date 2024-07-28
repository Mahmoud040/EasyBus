import 'package:flutter/material.dart';


class Roundedbutton extends StatelessWidget {
  Roundedbutton({@required this.onPressed,this.colour, this.title});

  final String title;
  final Color colour;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 30.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
