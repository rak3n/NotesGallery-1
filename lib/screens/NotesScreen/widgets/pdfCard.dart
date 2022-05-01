import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_gallery/models/note.dart';
import 'package:notes_gallery/provider/noteProvider.dart';
import 'package:notes_gallery/utils/constants/routes.dart';
import 'package:notes_gallery/widgets/indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class PdfCard extends StatefulWidget {
  final Note note;
  final String userId;
  PdfCard({required this.note, required this.userId});

  @override
  State<PdfCard> createState() => _PdfCardState();
}

class _PdfCardState extends State<PdfCard> {
  bool like = false;
  bool isLoading = true;
  @override
  void initState() {
    like = widget.note.likes.contains(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Indicator()
        : Consumer<NotesProvider>(
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
                                setState(() {
                                  like = noteProvider.useLikeOrDislike(
                                      widget.userId, widget.note);
                                });

                                print("done");
                              },
                              icon: Icon(like
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              color: Colors.red,
                            ),
                            Text(
                              widget.note.likes.length.toString(),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final url = Uri.parse(widget.note.url);
                            final response = await http.get(url);
                            final body = response.bodyBytes;
                            final tempStorage = await getTemporaryDirectory();
                            final path =
                                '${tempStorage.path}/${widget.note.name}.pdf';
                            File(path).writeAsBytesSync(body);
                            await Share.shareFiles([path]);
                            setState(() {
                              isLoading = false;
                            });
                          },
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
