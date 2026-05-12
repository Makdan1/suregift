import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import '../../main/presentation/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    final isLoggedIn = await ref.read(authRepositoryProvider).isLoggedIn();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const MainScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/suregifts_logo.jpeg',
              width: 150,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.card_giftcard,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack)
            .shimmer(delay: 1500.ms, duration: 1000.ms),
            const SizedBox(height: 24),
            Text(
              'SureGift',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )
            .animate()
            .fadeIn(delay: 1000.ms)
            .slideY(begin: 0.5, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
