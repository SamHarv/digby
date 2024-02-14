import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuListTile extends ConsumerWidget {
  final String menuItemTitle;
  final IconData menuItemIcon;
  final dynamic onMenuItemTap;

  const MenuListTile({
    super.key,
    required this.menuItemTitle,
    required this.menuItemIcon,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(
        menuItemIcon,
        size: 26,
        color: const Color.fromARGB(255, 0, 74, 173),
      ),
      title: Text(
        menuItemTitle,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      onTap: onMenuItemTap,
    );
  }
}
