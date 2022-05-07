class UserModel {
  final String uid;
  final String displayName;
  final bool isStudent;
  UserModel({
    required this.uid,
    required this.displayName,
    required this.isStudent,
  });

  factory UserModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      isStudent: json['isStudent'],
    );
  }
}
