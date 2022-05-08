import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/models/userModel.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/feed_tile.dart';
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
  final feedTextController = TextEditingController();
  Future<void> loadFeeds() async {
    await Provider.of<DiscussionProvider>(context, listen: false).fetchFeeds();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppBar(
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
            )
          ])),
      body: FutureBuilder(
        future: loadFeeds(),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.grey,
                  ))
                : Consumer<DiscussionProvider>(
                    builder: (ctx, feed, _) => ListView.builder(
                      itemCount: feed.feedList.length,
                      itemBuilder: (ctx, i) => FeedTile(
                        feed.feedList[i],
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Text(
                  "Cook down your doubts...",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.blueGrey,
                  ),
                ),
                content: SizedBox(
                  height: 300,
                  child: ListView(
                    children: [
                      TextField(
                        controller: feedTextController,
                        maxLength: 80,
                        maxLines: 7,
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
                      Provider.of<DiscussionProvider>(context, listen: false)
                          .postFeed(
                        UserModel(
                          uid: "uid",
                          displayName: "displayName",
                          isStudent: true,
                        ),
                        feedTextController.text,
                      );

                      Navigator.of(context).pop();
                      feedTextController.clear();
                    },
                    child: Text(
                      "POST",
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
      ),
    );
  }
}
