class ChangePassowrdParam {
  final String password;
  final String newPassword;
  final String confirmPassword;

  ChangePassowrdParam({
    required this.password,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': password,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}

