import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/presentaion/viewmodels/bus_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class BusGroupButton extends ConsumerStatefulWidget {
  final String dataType;
  BusGroupButton({Key? key, required this.dataType}) : super(key: key);

  @override
  _BusGroupButtonState createState() => _BusGroupButtonState();
}

class _BusGroupButtonState extends ConsumerState<BusGroupButton> {
  late List<String> buttons;
  late String selectedButton; // 선택된 버튼의 상태를 관리하는 변수

  // 학기 방학
  final List<String> semesterList = ['학기', '방학'];
  // 평일 주말
  final List<String> weekendList = ['평일', '주말'];
  // 기점
  final List<String> startList = ['복현', '영어'];

  @override
  void initState() {
    super.initState();
    // dataType에 따라 버튼 리스트와 기본 선택된 버튼 선택
    switch (widget.dataType) {
      case 'semester':
        buttons = semesterList;
        selectedButton = semesterList[0];
        break;
      case 'weekend':
        buttons = weekendList;
        selectedButton = weekendList[0];
        break;
      case 'start':
        buttons = startList;
        selectedButton = startList[0];
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0, // 버튼 간 가로 간격
        runSpacing: 4.0, // 버튼 간 세로 간격 (Wrap이 여러 줄일 경우)
        children: List.generate(
          buttons.length,
          (index) => ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0)),
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(50, 30)), // 높이 조정
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (selectedButton == buttons[index])
                    return Palette.mainColor; // 선택된 버튼 색상
                  return Colors.grey[300]!; // 기본 버튼 색상
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (selectedButton == buttons[index])
                    return Colors.white; // 선택된 버튼 텍스트 색상
                  return Colors.grey[600]!; // 기본 버튼 텍스트 색상
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // 모서리 둥글게
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                selectedButton = buttons[index]; // 버튼 클릭 시 선택된 버튼 업데이트
              });

              // ViewModel에서 데이터 가져오기 위한 값 설정
              int semester = ref.read(semesterProvider);
              int weekend = ref.read(weekendProvider);
              String route = ref.read(routeProvider);

              if (widget.dataType == "semester") {
                semester = (buttons[index] == '방학') ? 0 : 1;
                ref.read(semesterProvider.notifier).state = semester;
              } else if (widget.dataType == "weekend") {
                weekend = (buttons[index] == '평일') ? 0 : 1;
                ref.read(weekendProvider.notifier).state = weekend;
              } else if (widget.dataType == "start") {
                route = (buttons[index] == '복현') ? 's_bokhyun' : 's_english';
                ref.read(routeProvider.notifier).state = route;
              }

              ref
                  .read(busViewModelProvider)
                  .fetchBusSchedules(weekend, semester, route);
            },
            child: Text(
              buttons[index],
              style: TextStyle(fontSize: 13.0, letterSpacing: -0.5),
            ),
          ),
        ),
      ),
    );
  }
}
