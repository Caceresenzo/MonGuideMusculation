import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/user.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class CircularUserAvatar extends StatelessWidget {
  final User user;

  CircularUserAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.profilePictureFile == null) {
      return new CircleAvatar(
        child: Icon(Icons.account_circle),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(WixUtils.formatMediaFileUrl(user.profilePictureFile)),
    );
  }
}
