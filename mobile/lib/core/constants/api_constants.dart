class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  
  // Property endpoints
  static const String properties = '/properties';
  static const String propertyById = '/properties/';
  static const String propertyPhotos = '/properties/photos';
  static const String propertyDocuments = '/properties/documents';
  
  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  
  // Booking endpoints
  static const String bookings = '/bookings';
  static const String bookingById = '/bookings/';
  
  // Messages endpoints
  static const String messages = '/messages';
  static const String messageById = '/messages/';
}