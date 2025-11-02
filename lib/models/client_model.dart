class ClientModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  ClientModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
    if (id != null) {
      data['id'] = id!.toString();
    }
    return data;
  }

  String get fullName => '$firstName $lastName';

  ClientModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return ClientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
