import 'package:flutter/material.dart';

import '../constants.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    Key? key,
    this.icon,
    this.title,
    this.onPressed,
    this.color,
  }) : super(key: key);

  final IconData? icon;
  final String? title;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: ListTile(
          onTap: onPressed!,
          leading: Icon(
            icon!,
            color: color ?? Colors.grey,
          ),
          title: Text(
            title!,
            style: commonTextStyle.copyWith(color: color ?? Colors.grey),
          ),
        ),
      ),
    );
  }
}
