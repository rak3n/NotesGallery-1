import 'package:flutter/material.dart';
import 'package:notes_gallery/models/year_data.dart';
import 'package:notes_gallery/widgets/year_box.dart';

class BoxGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 10 / 15,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: data
          .map(
            (i) => InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: YearBox(yearName: i.yr, color: i.color)),
          )
          .toList(),
    );
  }
}
