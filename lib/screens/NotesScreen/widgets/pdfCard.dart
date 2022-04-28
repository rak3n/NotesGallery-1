import 'package:flutter/material.dart';
import 'package:notes_gallery/models/note.dart';
import 'package:notes_gallery/utils/constants/routes.dart';

class PdfCard extends StatelessWidget {
  final Note note;
  PdfCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  arguments: note.url);
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
                      onPressed: () {},
                      icon: Icon(Icons.favorite_outline),
                      color: Colors.red,
                    ),
                    Text(note.likes.length.toString())
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
    );
  }
}
