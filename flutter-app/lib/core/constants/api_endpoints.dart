import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _RemoteServer.socketUrl;

  static const String baseUrl = _RemoteServer.baseUrl;

  /// ### post
  static const String login = _Auth.login;

  static const String socialLogin = _Auth.socialLogin;

  static const String signup = _Auth.signup;

  static const String verifyCode = _Auth.verifyCode;

  static const String registerVerify = _Auth.registerVerify;

  static const String resetPassword = _Auth.resetPassword;

  static const String forgetPassword = _Auth.forgetPassword;

  static const String changePassword = _Auth.changePassword;

  static const String createNewPassword = _Auth.createNewPassword;

  /// ### post
  static const String refreshToken = _Auth.refreshToken;

  /// ### get
  static const String getUserNotifications = _Notification.getUserNotifications;

  /// ### post
  static const String readAllNotifications = _Notification.readAllNotifications;

  /// ### patch
  static String markNotificationAsRead({required String notificationId}) =>
      _Notification.markNotificationAsRead(notificationId);

  /// ### patch
  static const String markAllAsRead = _Notification.markAllAsRead;

  // ---------------------- USER -----------------------------
  
  /// ### get
  static String getuserbyId(String id) => _User.getuserbyId(id);

  /// ### get
  static const String getCurrentProfile = _User.getCurrentProfile;

  /// ### put
  static const String editProfile = _User.editProfile;

  /// ### put
  static const String uploadProfileAvatar = _User.uploadProfileAvatar;

  /// ### get
  static const String history = _User.history;


  // ---------------------- RIDE -----------------------------
  /// ### post
  static const String createRide = _Ride.createRide;
  static String updateRide(String id) => _Ride.updateRide(id);
  static String leaveRide(String id) => _Ride.leaveRide(id);
  static String finishRide(String id) => _Ride.finishRide(id);
  static String getRideById(String id) => _Ride.getRideById(id);
  static String joinRide(String id) => _Ride.joinRide(id);
  static String voteForKick(String id) => _Ride.voteForKick(id);
  static String deleteRide(String id) => _Ride.deleteRide(id);
  static const String filterRide = _Ride.filterRide;
  static String rateRide(String rideId) => _Ride.rateRide(rideId);
  static String changeBaggage(String rideId) => _Booking.changeBaggage(rideId);

  // ---------------------- Booking -----------------------------
  static String getAllBookingsForARide(String rideId) => _Booking.getAllBookingsForARide(rideId);
  static const String getMyBookings = _Booking.getMyBookings;

  // ---------------------- Message -----------------------------
  /// ### Get
  static const String getAllChat = _Message.getAllChat;
  /// ### Get
  static String getMessages(String chatId) => _Message.getMessages(chatId);
  /// ### Post
  static String sendMessage(String chatId) => _Message.sendMessage(chatId);
  /// ### Put
  static String messageRead(String messageId) => _Message.messageRead(messageId);
  /// ### Put
  static String editMessage(String messageId) => _Message.editMessage(messageId);
  /// ### Delete
  static String deleteMessage(String messageId) => _Message.deleteMessage(messageId);

}

//arrow360degree@gmail.com

class _RemoteServer {
  static const String socketUrl =
      'https://api.hopliftapp.com';

  static const String baseUrl =
      'https://api.hopliftapp.com/api/v1';
}

class _LocalHostWifi {
  static const String socketUrl = 'http://10.10.5.90:5006';

  static const String baseUrl = 'http://10.10.5.90:5006/api/v1';
}


class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  //static const String socialLogin = '$_authRoute/login/social';
  static const String socialLogin = '$_authRoute/social-login';
  static const String appleLogin = '$_authRoute/apple-login';
  static const String facebookLogin = '$_authRoute/facebook-login';
  static const String signup = '$_authRoute/register/init';
  static const String forgetPassword = '$_authRoute/forget-password';
  static const String refreshToken = '$_authRoute/refresh-access-token';
  static const String verifyCode = '$_authRoute/verify-code';
  static const String registerVerify = '$_authRoute/register/verify';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String changePassword = '$_authRoute/change-password';
  static const String createNewPassword = '$_authRoute/reset-password';
}



// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notification';
  static String markNotificationAsRead(String notificationId) =>
      '$_notificationRoute/$notificationId/read';

  static const String readAllNotifications =
      '$_notificationRoute/read-all';
  static const String markAllAsRead = '$_notificationRoute/mark-all-as-read';
  static const String getUserNotifications = '$_notificationRoute/user';
}

class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
  static String getuserbyId(String id) => '$_userRoute/$id';
  static const String getCurrentProfile = '$_userRoute/profile';
  static const String editProfile = '$_userRoute/';
  static const String uploadProfileAvatar = '$_userRoute/upload-avatar';
  static const String history = '$_userRoute/history';
}


// ---------------------- RIDE -----------------------------
class _Ride {
  static const String _rideRoute = '${ApiEndpoints.baseUrl}/ride';
  static const String createRide = _rideRoute;
  static String updateRide(String id) => "$_rideRoute/$id";
  static String leaveRide(String id) => "$_rideRoute/$id/leave";
  static String finishRide(String id) => "$_rideRoute/$id/finish";
  static const String filterRide = _rideRoute;
  static String getRideById(String id) => "$_rideRoute/$id";
  static String joinRide(String id) => "$_rideRoute/$id/join";
  static String voteForKick(String id) => "$_rideRoute/$id/kick";
  static String deleteRide(String id) => "$_rideRoute/$id";
  static String rateRide(String rideId) => "$_rideRoute/$rideId/rate";
  
}

class _Booking {
  static const String _bookingRoute = '${ApiEndpoints.baseUrl}/booking';
  static const String getMyBookings = "$_bookingRoute/my";
  static String getAllBookingsForARide(String rideId) => "$_bookingRoute/ride/$rideId";
  static String changeBaggage(String id) => "$_bookingRoute/$id";
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/message';
  
  static const String getAllChat = "$_messageRoute/rooms";
  /// Get
  static String getMessages(String chatId) => "$_messageRoute/$chatId";
  /// Post
  static String sendMessage(String chatId) => "$_messageRoute/$chatId";
  /// Put
  static String messageRead(String messageId) => "$_messageRoute/read/$messageId";
  /// Put
  static String editMessage(String messageId) => "$_messageRoute/$messageId";
  /// Delete
  static String deleteMessage(String messageId) => "$_messageRoute/$messageId";
}

