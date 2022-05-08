import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_gallery/models/note.dart';
import 'package:notes_gallery/provider/noteProvider.dart';
import 'package:notes_gallery/utils/constants/routes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class PdfCard extends StatefulWidget {
  final Note note;
  final String userId;
  bool isloading;
  PdfCard({
    required this.note,
    required this.userId,
    this.isloading = false,
  });

  @override
  State<PdfCard> createState() => _PdfCardState();
}

class _PdfCardState extends State<PdfCard> {
  bool like = false;

  void shareMyFile({
    required String noteUrl,
    required String fileName,
  }) async {
    setState(() {
      widget.isloading = true;
    });
    final url = Uri.parse(noteUrl);
    final response = await http.get(url);
    final body = response.bodyBytes;
    final tempStorage = await getTemporaryDirectory();
    final path = '${tempStorage.path}/$fileName.pdf';
    File(path).writeAsBytesSync(body);
    await Share.shareFiles([path]);
    setState(() {
      widget.isloading = false;
    });
  }

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
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                "~" + widget.note.subject,
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0, top: 5),
              child: IconButton(
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
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            like = noteProvider.useLikeOrDislike(
                              widget.userId,
                              widget.note,
                            );
                          });
                        },
                        icon: Icon(
                          like ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: like ? Colors.red : Colors.grey,
                      ),
                      Text(
                        widget.note.likes.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  widget.isloading
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade400,
                            strokeWidth: 0.8,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            shareMyFile(
                              noteUrl: widget.note.url,
                              fileName: widget.note.subject,
                            );
                          },
                          icon: Icon(Icons.share),
                          color: Colors.grey,
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
