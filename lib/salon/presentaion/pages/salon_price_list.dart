// SalonPriceList.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/multi_select.dart';
import '../../../screens/salon/price.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter/services.dart' show rootBundle;


class SalonPriceList extends StatefulWidget {
  const SalonPriceList({super.key});

  @override
  _SalonPriceListState createState() => _SalonPriceListState();
}

class _SalonPriceListState extends State<SalonPriceList> {
  List<Price> prices = [];
  List<String> selectedServiceTypes = [];

  @override
  void initState() {
    super.initState();
    loadPrices();
  }

  Future<void> loadPrices() async {
    String jsonData = await rootBundle.loadString('assets/test.json');
    var list = json.decode(jsonData) as List;
    setState(() {
      prices = list.map((data) => Price.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    // 필터링(필터링 안 했을 때는 전체 목록 보여주고, 필터링 했을 경우에는 해당 항목만 보여줌)
    List<Price> filteredPrices;
    if (selectedServiceTypes.isEmpty) {
      filteredPrices = prices;
    } else {
      filteredPrices = prices
          .where((price) => selectedServiceTypes.contains(price.serviceType))
          .toList();
    }

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '가격표'),
      drawer: const BaseDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MultiSelect(
            onSelectionChanged: (selectedTypes) {
              setState(() {
                selectedServiceTypes = selectedTypes;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPrices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPrices[index].serviceName ?? ''),
                  subtitle: Text('${filteredPrices[index].price ?? ''}원'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
