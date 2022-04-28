import 'package:flutter/material.dart';
import 'package:notes_gallery/models/note.dart';
import 'package:notes_gallery/provider/noteProvider.dart';
import 'package:notes_gallery/utils/constants/routes.dart';
import 'package:provider/provider.dart';

class PdfCard extends StatefulWidget {
  final Note note;
  final String userId;
  PdfCard({required this.note, required this.userId});

  @override
  State<PdfCard> createState() => _PdfCardState();
}

class _PdfCardState extends State<PdfCard> {
  bool like = false;
  @override
  void initState() {
    like = widget.note.likes.contains(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (ctx, noteProvider, _) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          //  / alignment: Alignment.bottomCenter,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.pdfViewer,
                    arguments: widget.note.url);
              },
              icon: Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // widget.note.likes.add(noteProvider.userId);
                          setState(() {
                            like = noteProvider.useLikeOrDislike(
                                widget.userId, widget.note);
                          });

                          print("done");
                        },
                        icon:
                            Icon(like ? Icons.favorite : Icons.favorite_border),
                        color: Colors.red,
                      ),
                      Text(
                        widget.note.likes.length.toString(),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
