import 'package:flutter/widgets.dart';

@immutable
class User {
  final String wixId;
  final String profilePictureFile;
  final String name;

  User({
    this.wixId,
    this.profilePictureFile,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return new User(
      wixId: data["_id"],
      profilePictureFile: data["image"] != null ? data["image"]["file_name"] : null,
      name: data["name"],
    );
  }
}
