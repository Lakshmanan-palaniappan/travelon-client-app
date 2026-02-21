import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorPage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 90,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),

              Text(
                "Something Went Wrong",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => context.go('/'),
                child: const Text("Go to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}