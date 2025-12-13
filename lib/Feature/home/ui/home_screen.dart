import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:herbal_app/Feature/home/ui/home_img_slider.dart';
import 'package:herbal_app/components/article_home_cart.dart';
import 'package:herbal_app/components/produk_cart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      floatingActionButton: SizedBox(
        height: 70,
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/ai-icon.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
              width: 30,
              height: 30,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            Text("Cari obat herbal"),
                          ],
                        ),
                      ),
                    ),
                    Icon(MfgLabs.heart),
                  ],
                ),
              ),
              HomeImgSlider(),
              SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Rekomendasi Produk"), Text("See more")],
                    ),
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      padding: EdgeInsets.only(left: 15),
                      separatorBuilder: (context, index) => SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        return ProdukCart(
                          namaProduk: "namaProduk1",
                          harga: "harga1",
                          linkImageProduk: "linkImageProduk",
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Insight Edukasi"), Text("See more")],
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      padding: EdgeInsets.only(left: 15),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: 15),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return HomeArticle();
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Insight Edukasi"), Text("See more")],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
