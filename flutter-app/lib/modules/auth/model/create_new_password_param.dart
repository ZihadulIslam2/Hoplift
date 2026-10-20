class CreateNewPasswordParam {
  final String email;
  final String newPassword;
  final String confirmNewPassword;

  CreateNewPasswordParam({required this.email, required this.newPassword, required this.confirmNewPassword});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
    };
  }
}
