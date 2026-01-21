import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herbal_app/Feature/home/bloc/home_bloc.dart';
import 'package:herbal_app/Feature/praktisi/bloc/praktisi_bloc.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';
import 'package:herbal_app/Feature/profile/ui/profil_view.dart';
import 'package:herbal_app/Feature/forum/ui/forums_home_view.dart';
import 'package:herbal_app/Feature/home/ui/home_screen.dart';
import 'package:herbal_app/Feature/praktisi/ui/praktisi_view.dart';
import 'package:herbal_app/Feature/product/ui/product_view.dart';
import 'package:herbal_app/core/dependecy_injector/service_locator.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selected = 0;
  final controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home BLoC - shared untuk semua screens yang membutuhkan
        BlocProvider<HomeBloc>(
          create: (context) => getIt<HomeBloc>()..add(LoadHomeDataEvent()),
        ),
        // Product BLoC
        BlocProvider<ProductBloc>(create: (context) => getIt<ProductBloc>()),
        // Praktisi BLoC
        BlocProvider<PraktisiBloc>(create: (context) => getIt<PraktisiBloc>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            ProductView(),
            ForumsHomeView(),
            PraktisiView(),
            ProfilView(),
          ],
        ),
        bottomNavigationBar: StylishBottomBar(
          option: AnimatedBarOptions(
            // iconSize: 32,
            // barAnimation: BarAnimation.liquid,
            iconStyle: IconStyle.animated,

            // opacity: 0.3,
          ),
          items: [
            BottomBarItem(
              icon: SvgPicture.asset(
                'assets/home-icon.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: Theme.of(context).primaryColor,
              unSelectedColor: Theme.of(context).disabledColor,
              title: Text("Beranda"),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                'assets/herbal-icon.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: Theme.of(context).primaryColor,
              unSelectedColor: Theme.of(context).hintColor,
              title: Text("Produk"),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                'assets/forum-icon.svg',
                height: 18,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: Theme.of(context).primaryColor,
              unSelectedColor: Theme.of(context).hintColor,
              title: Text("Forum"),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                'assets/praktisi-icon.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: Theme.of(context).primaryColor,
              unSelectedColor: Theme.of(context).hintColor,
              title: Text("Praktisi"),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                'assets/user-icon.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: Theme.of(context).primaryColor,
              unSelectedColor: Theme.of(context).hintColor,
              title: Text("Saya"),
            ),
          ],
          currentIndex: selected,
          onTap: (index) {
            setState(() {
              selected = index;
              controller.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}
