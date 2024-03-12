import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/salon/presentaion/widgets/my_booking_list.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/base_drawer.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";

class SalonMyBook extends ConsumerWidget {
  const SalonMyBook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: BaseAppBar(title: "예약 내역"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const BaseDrawer(),
      body: MyBookingList(),
    );
  }
}
