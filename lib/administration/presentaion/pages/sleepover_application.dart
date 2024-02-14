import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';

class SleepoverApplication extends StatefulWidget {
  const SleepoverApplication({super.key});

  @override
  State<SleepoverApplication> createState() => _SleepoverApplicationState();
}

class _SleepoverApplicationState extends State<SleepoverApplication> {
  //선택한 날짜 담는 변수
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '외박/외출'),
      drawer: const BaseDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //시작 일 선택
                Container(
                  margin: EdgeInsets.only(top: 150, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5),
                            locale: const Locale('ko', ''),
                          );
                          if (pickedDate != null && pickedDate != _startDate) {
                            setState(() {
                              _startDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.1, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(10), // 모서리 둥글기
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                spreadRadius: 1, // 그림자 확산 반경
                                blurRadius: 5, // 그림자 흐림 정도
                                offset: Offset(2, 3), // 그림자 위치
                              ),
                            ],
                          ),
                          child: Text('시작일 선택'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          '${_startDate == null ? '' : '${_startDate!.year}-${_startDate!.month}-${_startDate!.day}'}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                //종료일 선택
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5),
                            locale: const Locale('ko', ''),
                          );
                          if (pickedDate != null && pickedDate != _endDate) {
                            setState(() {
                              _endDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.1, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(10), // 모서리 둥글기
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                spreadRadius: 1, // 그림자 확산 반경
                                blurRadius: 5, // 그림자 흐림 정도
                                offset: Offset(2, 3), // 그림자 위치
                              ),
                            ],
                          ),
                          child: Text('종료일 선택'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          '${_endDate == null ? '' : '${_endDate!.year}-${_endDate!.month}-${_endDate!.day}'}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                //사유 글자
                Container(
                  margin: EdgeInsets.only(right: 170),
                  child: Text(
                    '사유',
                    style: TextStyle(fontSize: 25),
                  ),
                ),

                //input창
                Container(
                  width: 250,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.2, // 테두리 두께
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // 그림자 색상
                        spreadRadius: 1, // 그림자 확산 반경
                        blurRadius: 5, // 그림자 흐림 정도
                        offset: Offset(2, 3), // 그림자 위치
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 20),
                    child: TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '사유를 입력하세요',
                      ),
                    ),
                  ),
                ),

                //작성 완료 버튼
                Container(
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 29, 127, 159),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(130, 50),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // 테두리 둥글기
                            side: BorderSide(
                                color: Color.fromARGB(
                                    255, 255, 255, 255)) // 테두리 색상
                            ),
                      ),
                    ),
                    onPressed: () {
                      if (_startDate == null ||
                          _endDate == null ||
                          reasonController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('오류'),
                              content: Text('입력을 완료해주세요'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                '신청이 완료되었습니다.',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 29, 127, 159),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        '시작일: ${_startDate == null ? '' : '${_startDate!.year}-${_startDate!.month}-${_startDate!.day}'}'),
                                    Text(
                                        '종료일: ${_endDate == null ? '' : '${_endDate!.year}-${_endDate!.month}-${_endDate!.day}'}'),
                                    Text('사유: ${reasonController.text}'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, '/sleepover');
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      '작성완료',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
