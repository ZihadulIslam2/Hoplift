class ForgetPasswordParam {
  final String email;

  ForgetPasswordParam({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}

