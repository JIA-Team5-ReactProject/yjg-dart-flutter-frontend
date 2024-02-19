import "package:flutter/material.dart";
import "package:yjg/salon(admin)/presentation/widgets/service_tabbar.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";

class AdminSalonPriceList extends StatelessWidget {
  const AdminSalonPriceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: "가격표 관리"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: ServiceTabbar(),
    );
  }
}