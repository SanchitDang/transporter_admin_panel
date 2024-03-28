import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../dashboard/components/header.dart';
import '../main/components/side_menu.dart';
import 'components/all_users.dart';


class UsersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final MenuAppController menuAppController = Get.find<MenuAppController>();

    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  primary: false,
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Header(),
                      SizedBox(height: defaultPadding),
                      AllUsers()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
