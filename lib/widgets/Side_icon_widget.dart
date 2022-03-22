import 'package:flutter/material.dart';

class SideIcons extends StatelessWidget {
  const SideIcons({
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black38,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
