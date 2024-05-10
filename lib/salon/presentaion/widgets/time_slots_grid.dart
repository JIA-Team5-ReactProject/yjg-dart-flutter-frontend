import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_business_hours_viewmodel.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/booking_execution_modal.dart';
import 'package:yjg/shared/theme/theme.dart';

class TimeSlotsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTimeSlots = ref
        .watch(salonHoursProvider(ref.watch(selectedDateProvider).toString()));

    return asyncTimeSlots.when(
      data: (timeSlots) => GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          bool isSelected = timeSlots[index].time ==
              ref.watch(selectedTimeSlotProvider.notifier).state;
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Palette.textColor.withOpacity(0.7);
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side:
                        BorderSide(color: Palette.stateColor4.withOpacity(0.4)),
                  ),
                ),
              ),
              onPressed: timeSlots[index].available == true
                  ? () {
                      // `timeSlots[index].available`이 true일 때 실행할 로직
                      ref.read(selectedTimeSlotProvider.notifier).state =
                          timeSlots[index].time;

                      bookingExecutionModal(context, ref);
                    }
                  : null, // `timeSlots[index].available`이 false 또는 null일 때는 버튼 비활성화

              child: Text(
                timeSlots[index].time!,
                style: TextStyle(fontSize: 12.0, letterSpacing: -0.5),
              ),
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
