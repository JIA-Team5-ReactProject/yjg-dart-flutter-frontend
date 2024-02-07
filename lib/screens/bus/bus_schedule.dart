import 'package:flutter/material.dart';
import 'package:yjg/screens/bus/bus_dropdown_button.dart';
import 'package:yjg/screens/bus/bus_timetable.dart'; 
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/base_drawer.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';

class BusSchedule extends StatefulWidget {
  const BusSchedule({super.key});

  @override
  _BusScheduleState createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule> {
  String? selectedRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '버스 시간표'),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const BaseDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BusDropdownButton(
              onSelected: (value) {
                setState(() {
                  selectedRoute = value;
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: selectedRoute != null
                ? BusTimetable(selectedRoute: selectedRoute!)
                : Center(child: Text('노선을 선택해주세요.')
            ),
          ),
        ],
      ),
    );
  }
}
