

class LoginRequestParams {
  final String provider;
  final Map<String, dynamic> payload; // Map<String, dynamic>

  LoginRequestParams._({
    required this.provider,
    required this.payload,
  });

  LoginRequestParams.emailLogin({required String email, required String password})
      : this._(provider: 'email', payload: {'email': email, 'password': password});

  LoginRequestParams.googleLogin({required String idToken})
      : this._(provider: 'google', payload: {'token': idToken});

  LoginRequestParams.facebookLogin({required String accessToken})
      : this._(provider: 'facebook', payload: {'token': accessToken});

      
  Map<String, dynamic> toJson() {
    if(provider == 'email') {
      return payload;
    } else {
      return {
        'provider': provider,
        'token': payload['token'],
      };
    }
  }
}

class LoginResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  
  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      userId: map['userId'] ?? '',
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }
}
