import 'package:flutter/material.dart';

class HomeArticle extends StatelessWidget {
  const HomeArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 270,
          height: 150,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Text("datadatadatadatadatadatadata datadatadatadata"),
              Text("datadatadatadatadatadatadata datadatadatadata"),
            ],
          ),
        ),
      ],
    );
  }
}
