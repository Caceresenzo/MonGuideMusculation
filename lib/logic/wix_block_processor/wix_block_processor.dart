import 'package:flutter/cupertino.dart';
import 'package:mon_guide_musculation/models/wix.dart';

class WixBlockProcessor {
  List<WixBlockItem> blocks;

  WixBlockProcessor({this.blocks});

  List<List<WixBlockItem>> organize(BuildContext context) {
    List<List<WixBlockItem>> items = [];

    List<WixBlockItem> currentItems = [];

    blocks.forEach((block) {
      if (block.isTitle()) {
        if (currentItems.isNotEmpty) {
          items.add(currentItems);
        }

        currentItems = [block];
      } else {
        currentItems.add(block);
      }
    });
    items.add(currentItems);

    return items;
  }
}
