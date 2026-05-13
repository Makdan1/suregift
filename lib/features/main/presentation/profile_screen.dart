import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../presentation/main_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SureGifts User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'user@suregifts.com.ng',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // Theme Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.dark_mode_outlined),
                      SizedBox(width: 16),
                      Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Switch(
                    value: themeMode == ThemeMode.dark,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            AppButton(
              text: 'Logout',
              color: Colors.red[400],
              onPressed: () async {
                await ref.read(authRepositoryProvider).logout();
                ref.invalidate(mainTabIndexProvider); // Reset tab index to 0
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
