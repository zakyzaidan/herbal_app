import 'package:flutter/material.dart';

class ProdukCart extends StatelessWidget {
  final String namaProduk;
  final String harga;
  final String linkImageProduk;

  const ProdukCart({
    super.key,
    required this.namaProduk,
    required this.harga,
    required this.linkImageProduk,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 220,
          width: 150,
          padding: EdgeInsets.all(10),
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
            children: [Text(linkImageProduk), Text(namaProduk), Text(harga)],
          ),
        ),
      ],
    );
  }
}
