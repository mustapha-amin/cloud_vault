class CloudVaultUser {
  String? id;
  String? name;
  String? email;

  CloudVaultUser({this.id, this.name, this.email});

  factory CloudVaultUser.fromFireStore(Map<String, dynamic> json) {
    return CloudVaultUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
