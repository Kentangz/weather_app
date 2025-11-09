class CustomLocationServiceDisabledException implements Exception {
  final String message = "Location services (GPS) are disabled.";
  @override
  String toString() => message;
}

class CustomLocationPermissionDeniedException implements Exception {
  final String message = "Location permissions are permanently denied.";
  @override
  String toString() => message;
}
