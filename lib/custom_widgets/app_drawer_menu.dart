import 'package:digby/custom_widgets/menu_list_tile.dart';
import 'package:digby/game_logic/game_play_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/providers.dart';

class AppDrawerMenu extends ConsumerWidget {
  final GamePlayLogic gamePlayLogic;
  final WidgetRef ref;
  const AppDrawerMenu({
    super.key,
    required this.gamePlayLogic,
    required this.ref,
  });

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
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.white,
              child: Image.asset('images/2.png'),
            ),
            const Divider(),
            MenuListTile(
                menuItemTitle: 'RESUME GAME',
                menuItemIcon: Icons.play_arrow,
                onMenuItemTap: () {
                  gamePlayLogic.resumeGame();
                  Navigator.pop(context);
                }),
            const Divider(),
            ref.watch(isInfiniteMode)
                ? MenuListTile(
                    menuItemTitle: 'CLASSIC MODE',
                    menuItemIcon: Icons.moving,
                    onMenuItemTap: () =>
                        ref.read(isInfiniteMode.notifier).state = false,
                  )
                : MenuListTile(
                    menuItemTitle: 'INFINITE MODE',
                    menuItemIcon: Icons.all_inclusive,
                    onMenuItemTap: () =>
                        ref.read(isInfiniteMode.notifier).state = true,
                  ),
            const Divider(),
            ref.watch(isDarkMode)
                ? MenuListTile(
                    menuItemTitle: 'DAY MODE',
                    menuItemIcon: Icons.sunny,
                    onMenuItemTap: () =>
                        ref.read(isDarkMode.notifier).state = false,
                  )
                : MenuListTile(
                    menuItemTitle: 'NIGHT MODE',
                    menuItemIcon: Icons.dark_mode,
                    onMenuItemTap: () =>
                        ref.read(isDarkMode.notifier).state = true,
                  ),
            // Below causes speed from prev game to be used rather than default
            // const Divider(),
            // MenuListTile(
            //   menuItemTitle: 'Restart Game',
            //   menuItemIcon: Icons.restart_alt,
            //   onMenuItemTap: () {
            //     Navigator.pop(context);
            //     gamePlayLogic.resetGame();
            //   },
            // ),
            const Divider(),
            MenuListTile(
              menuItemTitle: 'CONTACT',
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
