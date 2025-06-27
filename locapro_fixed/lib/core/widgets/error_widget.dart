import 'package:flutter/material.dart';
import '../error/exceptions.dart';

class CustomErrorWidget extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[  
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (error is NetworkException) {
      return Icons.wifi_off;
    } else if (error is ApiException) {
      final apiError = error as ApiException;
      if (apiError.isUnauthorized || apiError.isForbidden) {
        return Icons.lock;
      } else if (apiError.isNotFound) {
        return Icons.search_off;
      } else if (apiError.isServerError) {
        return Icons.cloud_off;
      }
    } else if (error is ValidationException) {
      return Icons.error_outline;
    }
    return Icons.error;
  }

  String _getErrorMessage() {
    if (error is NetworkException) {
      return 'Vérifiez votre connexion internet et réessayez.';
    } else if (error is ApiException) {
      final apiError = error as ApiException;
      if (apiError.isUnauthorized) {
        return 'Session expirée. Veuillez vous reconnecter.';
      } else if (apiError.isForbidden) {
        return 'Vous n\'avez pas les permissions nécessaires.';
      } else if (apiError.isNotFound) {
        return 'La ressource demandée n\'existe pas.';
      } else if (apiError.isServerError) {
        return 'Une erreur serveur s\'est produite. Veuillez réessayer plus tard.';
      }
      return apiError.message;
    } else if (error is ValidationException) {
      final validationError = error as ValidationException;
      return validationError.errors.values.first.first;
    }
    return 'Une erreur inattendue s\'est produite.';
  }
}