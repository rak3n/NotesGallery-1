import 'package:flutter/material.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/helper_function.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedTile extends StatelessWidget {
  final Feed feed;
  const FeedTile(
    this.feed,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 8,
        right: 8,
        bottom: 4,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(6),
        child: Container(
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        getFirstChar(feed.postedBy.displayName),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      feed.postedBy.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
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
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/comment',
                            arguments: feed.feedId,
                          );
                        },
                        icon: Icon(
                          Icons.comment,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        feed.commentList.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  ),
                  Consumer<DiscussionProvider>(
                    builder: (ctx, feedProvider, _) => IconButton(
                      onPressed: () {
                        Provider.of<DiscussionProvider>(context, listen: false)
                            .reportUserFeed(
                                feedId: feed.feedId,
                                uid: feedProvider.uid ?? "");

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                              content: Text("Feed reported successfully")));
                      },
                      icon: Icon(
                        Icons.report_outlined,
                        color: feed.isReported ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  Consumer<DiscussionProvider>(
                    builder: (ctx, feedProvider, _) => Visibility(
                      visible: feedProvider.uid == feed.postedBy.uid,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<DiscussionProvider>(context,
                                  listen: false)
                              .deleteFeed(
                                  feedId: feed.feedId,
                                  uid: feedProvider.uid ?? "");

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text("Feed deleted successfully"),
                              ),
                            );
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
