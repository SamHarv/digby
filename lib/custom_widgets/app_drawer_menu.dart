import 'package:digby/custom_widgets/menu_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/providers.dart';

class AppDrawerMenu extends ConsumerWidget {
  const AppDrawerMenu({super.key});

  void _sendEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'oxygentech@protonmail.com',
    );
    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.white,
              child: Image.asset('images/2.png'),
            ),
            const Divider(),
            ref.watch(isInfiniteMode)
                ? MenuListTile(
                    menuItemTitle: 'Classic Mode',
                    menuItemIcon: Icons.moving,
                    onMenuItemTap: () =>
                        ref.read(isInfiniteMode.notifier).state = false,
                  )
                : MenuListTile(
                    menuItemTitle: 'Infinite Mode',
                    menuItemIcon: Icons.all_inclusive,
                    onMenuItemTap: () =>
                        ref.read(isInfiniteMode.notifier).state = true,
                  ),
            const Divider(),
            ref.watch(isDarkMode)
                ? MenuListTile(
                    menuItemTitle: 'Day Mode',
                    menuItemIcon: Icons.sunny,
                    onMenuItemTap: () =>
                        ref.read(isDarkMode.notifier).state = false,
                  )
                : MenuListTile(
                    menuItemTitle: 'Night Mode',
                    menuItemIcon: Icons.dark_mode,
                    onMenuItemTap: () =>
                        ref.read(isDarkMode.notifier).state = true,
                  ),
            const Divider(),
            MenuListTile(
              menuItemTitle: 'Contact',
              menuItemIcon: Icons.email,
              onMenuItemTap: () => _sendEmail(),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
