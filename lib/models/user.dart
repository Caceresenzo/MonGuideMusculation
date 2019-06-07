class User {
  String wixId;
  String profilePictureFile;
  String name;

  User({this.wixId, this.profilePictureFile, this.name});

  factory User.fromJson(Map<String, dynamic> data) {
    return new User(
      wixId: data["_id"],
      profilePictureFile: data["image"] != null ? data["image"]["file_name"] : null,
      name: data["name"],
    );
  }
}
