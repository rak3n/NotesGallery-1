import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/discussionProvider.dart';
import 'package:provider/provider.dart';

class DiscussionPanelScreen extends StatelessWidget {
  const DiscussionPanelScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/discussion';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: () {
              Provider.of<DiscussionProvider>(context, listen: false)
                  .fetchFeeds();
            },
            child: Text("USE ME"),
          ),
        ),
      ),
    );
  }
}
