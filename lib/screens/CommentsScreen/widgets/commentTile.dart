import 'package:flutter/material.dart';
import 'package:notes_gallery/models/commentModel.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/helper_function.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  const CommentTile({
    required this.comment,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    getFirstChar(comment.userInfo.displayName),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 60),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userInfo.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      comment.commentText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
