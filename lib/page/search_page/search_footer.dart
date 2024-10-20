
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFooter extends StatefulWidget {
  const SearchFooter({Key? key}) : super(key: key);

  @override
  _SearchFooterState createState() => _SearchFooterState();
}

class _SearchFooterState extends State<SearchFooter> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Get.toNamed(AppRoute.HOME_PAGE);
      } else if (index == 1) {
        Get.toNamed(AppRoute.SEARCH_PAGE);
      } else if (index == 2) {
        Get.toNamed(AppRoute.ORDER_PAGE);
      } else if (index == 3) {
         Get.toNamed(AppRoute.STORE_PAGE);
      } else if (index == 4) {
        Get.toNamed(AppRoute.PROFILE_PAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppColor.mainColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
