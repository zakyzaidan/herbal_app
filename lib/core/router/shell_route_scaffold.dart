// lib/core/router/shell_route_scaffold.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavigation extends StatefulWidget {
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      route: '/home',
      icon: 'assets/home-icon.svg',
      label: 'Beranda',
    ),
    NavigationItem(
      route: '/products',
      icon: 'assets/herbal-icon.svg',
      label: 'Produk',
    ),
    NavigationItem(
      route: '/forums',
      icon: 'assets/forum-icon.svg',
      label: 'Forum',
    ),
    NavigationItem(
      route: '/practitioners',
      icon: 'assets/praktisi-icon.svg',
      label: 'Praktisi',
    ),
    NavigationItem(
      route: '/profile',
      icon: 'assets/user-icon.svg',
      label: 'Saya',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();
    final index = _navigationItems.indexWhere(
      (item) => location.startsWith(item.route),
    );
    if (index != -1 && index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      context.go(_navigationItems[index].route);
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(iconStyle: IconStyle.animated),
        items: _navigationItems.map((item) {
          return BottomBarItem(
            icon: SvgPicture.asset(
              item.icon,
              height: item.label == 'Produk' ? 24 : null,
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
            selectedColor: Theme.of(context).primaryColor,
            unSelectedColor: Theme.of(context).disabledColor,
            title: Text(item.label),
          );
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class NavigationItem {
  final String route;
  final String icon;
  final String label;

  NavigationItem({
    required this.route,
    required this.icon,
    required this.label,
  });
}
