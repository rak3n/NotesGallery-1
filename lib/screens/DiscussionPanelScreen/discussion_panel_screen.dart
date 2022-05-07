import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/helper_function.dart';
import 'package:provider/provider.dart';

class DiscussionPanelScreen extends StatefulWidget {
  const DiscussionPanelScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/discussion';

  @override
  State<DiscussionPanelScreen> createState() => _DiscussionPanelScreenState();
}

class _DiscussionPanelScreenState extends State<DiscussionPanelScreen> {
  Future<void> loadFeeds() async {
    await Provider.of<DiscussionProvider>(context, listen: false).fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // appBar: AppBar(
      //   title: Text("Let's Discuss"),
      //   backgroundColor: Color.fromRGBO(28, 101, 133, 1),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // toolbarOpacity: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discussion",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(28, 101, 133, 1)),
            ),
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(169, 170, 183, 1),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: loadFeeds(),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<DiscussionProvider>(
                    builder: (ctx, feed, _) => ListView.builder(
                      itemCount: feed.feedList.length,
                      itemBuilder: (ctx, i) => FeedTile(
                        feed.feedList[i],
                      ),
                    ),
                  ),
      ),
    );
  }
}

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
                        onPressed: () {},
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.report_outlined,
                      color: Colors.grey,
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
