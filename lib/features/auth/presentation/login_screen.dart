import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/common_widgets.dart';
import '../data/auth_repository.dart';
import '../../main/presentation/main_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/suregifts_logo.jpeg',
                    width: 100,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.card_giftcard,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.elasticOut),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.displayLarge,
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Log in to your account to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 48),
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                AppTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                const Spacer(),
                AppButton(
                  text: 'Log In',
                  isLoading: _isLoading,
                  onPressed: _login,
                ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
