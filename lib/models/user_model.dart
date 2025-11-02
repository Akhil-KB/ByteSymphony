class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      email: json['email'] as String?,
      name: json['name'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (name != null) return name!;
    if (firstName != null) return firstName!;
    if (email != null) return email!;
    return 'User';
  }
}
