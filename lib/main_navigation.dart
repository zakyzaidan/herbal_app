import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/home/bloc/home_bloc.dart';
import 'package:herbal_app/Feature/profile/ui/profil_view.dart';
import 'package:herbal_app/Feature/forum/ui/forums_home_view.dart';
import 'package:herbal_app/Feature/home/ui/home_screen.dart';
import 'package:herbal_app/Feature/praktisi/ui/praktisi_view.dart';
import 'package:herbal_app/Feature/product/ui/product_view.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selected = 0;
  final controller = PageController(initialPage: 0);
  final authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    _listenToRoleChanges();
  }

  void _listenToRoleChanges() {
    // Listen to role changes and rebuild when role changes
    authServices.watchRoles().listen((user) {
      if (user != null && mounted) {
        // Trigger rebuild by updating AuthBloc state
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            ProductView(),
            ForumsHomeView(),
            PraktisiView(),
            ProfilView(),
            // Home(),
            // Add(),
            // Profile(),
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
