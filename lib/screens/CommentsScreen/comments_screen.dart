import 'package:flutter/material.dart';
import 'package:notes_gallery/models/commentModel.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/models/userModel.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/CommentsScreen/widgets/commentTile.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/helper_function.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);
  static const routeName = '/comment';

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String feedId = ModalRoute.of(context)?.settings.arguments as String;
    var feed = Provider.of<DiscussionProvider>(context, listen: true)
        .feedList
        .firstWhere((element) => element.feedId == feedId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text(
              "Add Comment",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    content: SizedBox(
                      height: 250,
                      child: ListView(
                        children: [
                          TextField(
                            controller: commentController,
                            maxLength: 40,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              hintText: "Write Down Something...!",
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                        ),
                        onPressed: () {
                          Provider.of<DiscussionProvider>(context,
                                  listen: false)
                              .postComment(
                            feedId: feedId,
                            userInfo: UserModel(
                              uid: "uid",
                              displayName: "displayName",
                              isStudent: true,
                            ),
                            commentText: commentController.text,
                          );

                          Navigator.of(context).pop();
                          commentController.clear();
                        },
                        child: Text(
                          "Go",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
        backgroundColor: Color.fromRGBO(28, 101, 133, 1),
        // title: Text(
        //   "Comments",
        //   style: TextStyle(
        //     fontSize: 17,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                        right: 8.0,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueGrey,
                            child: Text(
                              getFirstChar(feed.postedBy.displayName),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feed.postedBy.displayName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2.0,
                                      ),
                                      child: Text(
                                        feed.date.split('T')[0],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ))
                                ],
                              )),
                        ],
                      )),
                ),
                Divider(
                  indent: 18,
                  endIndent: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                    bottom: 8,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 30,
                      left: 4,
                      right: 4,
                    ),
                    child: Text(
                      feed.feedText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Comments :"),
          ),
          feed.commentList.isEmpty
              ? Center(
                  heightFactor: 10,
                  child: Text(
                    "No comments",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Column(
                  children: feed.commentList
                      .map(
                        (e) => CommentTile(
                          comment: e,
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
