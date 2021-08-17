import 'package:flutter/material.dart';

class Applybutton extends StatelessWidget {
  const Applybutton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
