import 'package:admin/screens/debug_screen.dart';
import 'package:admin/screens/drivers/drivers_screen.dart';
import 'package:admin/screens/set_price/views/set_price_screen.dart';
import 'package:admin/screens/trips/trips_screen.dart';
import 'package:admin/screens/warehouses/views/warehouses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../invoice/challan_page.dart';
import '../../invoice/invoice_page.dart';
import '../../users/users_screen.dart';
import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MainScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Users",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UsersScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Drivers",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DriversScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Warehouses",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      WarehousesScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Delivery",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TripsScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Set Price",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SetPrice(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Generate Bill",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      InvoicePage(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Generate Challan",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ChallanPage(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Debug Screen",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DeBugScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
