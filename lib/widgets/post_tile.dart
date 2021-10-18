import 'package:flutter/material.dart';
import 'package:reach_me/widgets/customized_widgets.dart';
import 'package:reach_me/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: cachedNetworkImage(post.mediaLink),
    );
  }
}
