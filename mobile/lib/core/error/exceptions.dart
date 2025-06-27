class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isBadRequest => statusCode == 400;
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network connection error'});

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class StorageException implements Exception {
  final String message;
  final String? path;

  StorageException({
    required this.message,
    this.path,
  });

  @override
  String toString() {
    if (path != null) {
      return 'StorageException: $message (Path: $path)';
    }
    return 'StorageException: $message';
  }
}

class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException(this.errors);

  @override
  String toString() {
    return 'ValidationException: ${errors.toString()}';
  }
}