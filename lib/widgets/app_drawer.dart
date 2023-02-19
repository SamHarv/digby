import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Widget buildListTile(String title, IconData icon, dynamic tapHandler) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(
        icon,
        size: 26,
        color: const Color.fromARGB(255, 0, 74, 173),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      onTap: tapHandler,
    );
  }

  void _sendEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'oxygentech@protonmail.com',
    );
    launchUrl(emailLaunchUri);
    //await before launchUrl
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    final isInfiniteMode = ref.watch(infiniteMode);
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
            isInfiniteMode
                ? buildListTile(
                    'Classic Mode',
                    Icons.moving,
                    () => ref.read(infiniteMode.notifier).state = false,
                  )
                : buildListTile(
                    'Infinite Mode',
                    Icons.all_inclusive,
                    () => ref.read(infiniteMode.notifier).state = true,
                  ),
            const Divider(),
            isDarkMode
                ? buildListTile(
                    'Day Mode',
                    Icons.sunny,
                    () => ref.read(darkMode.notifier).state = false,
                  )
                : buildListTile(
                    'Night Mode',
                    Icons.dark_mode,
                    () => ref.read(darkMode.notifier).state = true,
                  ),
            const Divider(),
            buildListTile(
              'Contact',
              Icons.email,
              () => _sendEmail(),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
