class UpdateProfileParam {
  final String id;
  String? name;
  String? email;
  String? phoneNumber;

  UpdateProfileParam({required this.id, this.name, this.email, this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}