import 'package:flutter/material.dart';

class reuseablecard extends StatelessWidget {
  reuseablecard({@required this.cardChild, this.gesture,this.taken});


  final Widget cardChild;
  final Function gesture;
  final bool taken;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gesture,
      child: Container(
        height: 150.0,
        child: cardChild,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(

          color: taken?Colors.grey:Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
