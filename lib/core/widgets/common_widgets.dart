import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import '../theme/app_theme.dart';
import '../navigation/navigation_service.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF25262B) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final Color? color;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SpinKitThreeBounce(color: Colors.white, size: 24)
            : Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class NiceErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onRetry;

  const NiceErrorWidget({super.key, required this.message, this.onRetry});

  @override
  State<NiceErrorWidget> createState() => _NiceErrorWidgetState();
}

class _NiceErrorWidgetState extends State<NiceErrorWidget> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 24),
            Text(
              _formatErrorMessage(widget.message),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (widget.message.length > 50)
              Text(
                'Technical details have been logged.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                child: AppButton(
                  text: 'Try Again',
                  isLoading: _isRetrying,
                  onPressed: () async {
                    setState(() => _isRetrying = true);
                    widget.onRetry?.call();
                    // Small delay to show the indicator if the retry is instant
                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) setState(() => _isRetrying = false);
                  },
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
    );
  }

  String _formatErrorMessage(String msg) {
    if (msg.contains('401')) return 'Your session has expired. Please log in again.';
    if (msg.contains('404')) return 'No data available for this request.';
    if (msg.contains('400')) return 'Invalid request. Please check your inputs.';
    if (msg.contains('SocketException') || msg.contains('Connection') || msg.contains('host lookup')) {
      return 'No internet connection. Please check your network.';
    }
    if (msg.contains('timeout')) return 'The request timed out. Please try again.';
    return 'Something went wrong. Please try again later.';
  }
}

class TopSnackbar {
  static void show(BuildContext? context, dynamic error, {bool isError = true}) {
    final String message = _parseErrorMessage(error);
    final actualContext = context ?? NavigationService.navigatorKey.currentContext;
    if (actualContext == null) return;
    
    final overlay = Overlay.of(actualContext);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: -1, end: 0, duration: 400.ms, curve: Curves.easeOutBack)
           .then(delay: 2.5.seconds)
           .slideY(begin: 0, end: -2, duration: 500.ms, curve: Curves.easeIn),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 3500), () {
      entry.remove();
    });
  }

  static String _parseErrorMessage(dynamic error) {
    if (error is String) {
      if (error.contains('400')) return 'Invalid request. Please check your data.';
      if (error.contains('401')) return 'Session expired. Please log in again.';
      if (error.contains('Connection')) return 'Network error. Please check your internet.';
      return error;
    }
    
    if (error is DioException) {
      if (error.response?.statusCode == 400) return 'The request was invalid. Please try again.';
      if (error.response?.statusCode == 401) return 'Unauthorized. Please sign in again.';
      if (error.response?.statusCode == 403) return 'Access denied. You do not have permission.';
      if (error.response?.statusCode == 404) return 'Resource not found.';
      if (error.type == DioExceptionType.connectionTimeout) return 'Connection timed out.';
      if (error.type == DioExceptionType.receiveTimeout) return 'Server not responding.';
      return 'Unexpected network error occurred.';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }
}
