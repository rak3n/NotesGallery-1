import 'package:flutter/material.dart';
import 'package:notes_gallery/models/userModel.dart';
import 'package:notes_gallery/provider/authProvider.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/feed_tile.dart';
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
  bool showErrorText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
        future: loadFeeds(),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadFeeds,
                    color: Colors.grey,
                    child: Consumer<DiscussionProvider>(
                      builder: (ctx, feed, _) => feed.feedList.isEmpty
                          ? Center(
                              heightFactor: 20,
                              child: Text(
                                "Nothing discussed yet!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: feed.feedList.length,
                              itemBuilder: (ctx, i) => FeedTile(
                                feed.feedList[i],
                              ),
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
                        onChanged: (val) {
                          setState(() {
                            showErrorText = false;
                          });
                        },
                      ),
                      Visibility(
                        visible: showErrorText,
                        child: Text(
                          "Post field cannot be left empty!",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Consumer<Authentication>(
                    builder: (ctx, auth, _) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: feedTextController.text.isEmpty
                          ? () {
                              setState(() {
                                showErrorText = true;
                              });
                            }
                          : () {
                              Provider.of<DiscussionProvider>(context,
                                      listen: false)
                                  .postFeed(
                                currentUser: auth.currentUser ??
                                    UserModel(
                                      uid: "",
                                      displayName: "",
                                      isStudent: true,
                                    ),
                                feedText: feedTextController.text,
                              );
                              setState(() {
                                showErrorText = false;
                              });
                              Navigator.of(context).pop();
                              feedTextController.clear();
                              loadFeeds();
                            },
                      child: Text(
                        "POST",
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
