class UserEntity {
  final int? id;
  final String email;
  final String username;
  final String? token;

  const UserEntity({this.id, required this.email, required this.username, this.token});
}
