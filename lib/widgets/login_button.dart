import 'package:flutter/material.dart';

import '../constants.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
        decoration: const BoxDecoration(
          color: amber,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: commonTextStyle.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
