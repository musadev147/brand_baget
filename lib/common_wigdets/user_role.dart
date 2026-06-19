enum UserRole {
  client,
  creator;

  String get value => name;

  static UserRole fromString(String? role) {
    if (role == null || role.isEmpty) {
      throw Exception("Invalid user role: (empty)");
    }
    switch (role.toLowerCase()) {
      case 'client':
      case 'brand':
        return UserRole.client;
      case 'creator':
      case 'influencer':
        return UserRole.creator;
      default:
        throw Exception("Invalid user role: $role");
    }
  }
}
