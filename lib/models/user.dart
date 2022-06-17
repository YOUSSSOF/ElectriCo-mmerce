class User {
  final String username;
  final String email;
  dynamic profilePhoto;
  final bool isAdmin;
  User({required this.username, required this.email, this.profilePhoto,required this.isAdmin});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
      isAdmin: json['is_staff']
    );
  }
}
