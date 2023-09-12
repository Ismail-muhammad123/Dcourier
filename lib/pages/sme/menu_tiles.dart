import 'package:flutter/material.dart';

import '../../constants.dart';

class MenuTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final IconData? leading;
  final IconData? trailing;
  final Widget? subTitle;
  const MenuTile({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
    this.subTitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        leading,
        color: accentColor,
        size: 30,
      ),
      subtitle: subTitle,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: accentColor,
        ),
      ),
      trailing: Icon(
        trailing,
        color: accentColor,
        size: 40,
      ),
    );
  }
}
