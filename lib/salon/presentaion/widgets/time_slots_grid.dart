import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/booking_execution_modal.dart';
import 'package:yjg/shared/theme/theme.dart';

class TimeSlotsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeSlots = ref.watch(timeSlotsProvider);
    final selectedTimeSlot = ref.watch(selectedTimeSlotProvider.state); 
    final selectedDate = ref.watch(selectedDateProvider.state).state;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 한 줄에 4개의 그리드 아이템
        childAspectRatio: 2, // 그리드 아이템의 가로세로 비율
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        bool isSelected = timeSlots[index] == selectedTimeSlot.state; // 현재 타임슬롯이 선택된 상태인지 확인
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (isSelected) return Color.fromARGB(255, 86, 90, 200); // 선택된 경우의 색
                  return Palette.backgroundColor; // 기본 배경색
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (isSelected) return Colors.white; // 선택된 경우의 글자색
                  return Palette.textColor.withOpacity(0.7); // 기본 글자색
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Palette.stateColor4.withOpacity(0.4)),
                ),
              ),
            ),
            onPressed: () {
              ref.read(selectedTimeSlotProvider.state).state = timeSlots[index];
              
              selectedDate == null ? null : bookingExecutionModal(context, ref); // 선택된 날짜가 없으면 예약 실행 모달, 있으면 다음 모달 호출
            },
            child: Text(
              timeSlots[index],
              style: TextStyle(fontSize: 12.0, letterSpacing: -0.5),
            ),
          ),
        );
      },
    );
  }
}