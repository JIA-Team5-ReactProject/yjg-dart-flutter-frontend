import 'package:flutter/material.dart';
import 'package:yjg/administration/data/data_sources/sleepover_data_source.dart';
import 'package:yjg/administration/presentaion/widgets/sleepover_widget.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class Sleepover extends StatefulWidget {
  const Sleepover({Key? key}) : super(key: key);

  @override
  State<Sleepover> createState() => _SleepoverState();
}

class _SleepoverState extends State<Sleepover> {
  Future<List<dynamic>>? _sleepoverApplications;
  final _sleepoverDataSource = SleepoverDataSource();

  @override
  void initState() {
    super.initState();
    _loadSleepoverApplications();
  }

  void _loadSleepoverApplications() {
    setState(() {
      _sleepoverApplications = fetchSleepoverApplications();
    });
  }

  Future<List<dynamic>> fetchSleepoverApplications() async {
    try {
      final response = await _sleepoverDataSource.fetchSleepoverApplications();

      final result = response.data;
      if (result is Map &&
          result.containsKey('absence_lists') &&
          result['absence_lists']['data'] is List) {
        return result['absence_lists']['data'];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('예약 불러오기를 실패하였습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '외박/외출'),
      drawer: BaseDrawer(),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                BlueMainRoundedBox(),
                Container(
                  width: 260,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 244, 244, 244)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/sleepover_application');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add_outlined, size: 30),
                        SizedBox(width: 10),
                        Text('외박/외출 신청하기'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //신청 내역 글자
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Text('신청 내역'),
          ),

          //선
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _sleepoverApplications,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    '현재 신청된 외박/외출이 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final application = snapshot.data![index];
                      return Container(
                        alignment: Alignment.center,
                        child: SleepoverWidget(
                          id: application['id'],
                          apply: application['status'],
                          startDate: application['start_date'],
                          lastDate: application['end_date'],
                          content: application['content'],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
