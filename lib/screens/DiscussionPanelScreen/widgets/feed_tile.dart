import 'package:flutter/material.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/screens/DiscussionPanelScreen/widgets/helper_function.dart';

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
                  left: 12.0,
                  right: 12.0,
                  top: 16.0,
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
                ),
              ),
              Divider(
                indent: 18,
                endIndent: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 12.0,
                  right: 12.0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: feed.commentList.length > 0
                        ? [
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
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              feed.commentList.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            )
                          ]
                        : [],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.report_outlined,
                          color: Colors.black,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
