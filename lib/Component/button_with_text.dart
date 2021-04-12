import 'package:flutter/material.dart';


class ButtonWithText extends StatelessWidget {
  final String txt;
  final IconData icon;
  final Function fn;
  final Color color;
  const ButtonWithText({
    Key key, @required this.txt, @required this.icon,@required this.fn,@required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: fn,
          color: Color(0xff043b48),
          padding: EdgeInsets.all(10.0),
          child: Column( // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Icon(icon, color: color,),
              Text(txt, style: TextStyle(color: color),)
            ],
          ),
        ),
      ],
    );
  }
}
