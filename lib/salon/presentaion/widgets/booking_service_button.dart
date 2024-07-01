import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:yjg/salon/presentaion/viewmodels/booking_select_id_viewmodel.dart';
import "package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart";
import "package:yjg/salon/presentaion/viewmodels/service_viewmodel.dart";
import "package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart";
import "package:yjg/salon/presentaion/widgets/booking_next_modal.dart";
import "package:yjg/shared/theme/palette.dart";
import 'package:intl/intl.dart';

class BookingServiceButton extends ConsumerStatefulWidget {
  const BookingServiceButton({super.key});

  @override
  _BookingServiceButtonState createState() => _BookingServiceButtonState();
}

class _BookingServiceButtonState extends ConsumerState<BookingServiceButton> {
  String? _selectedServiceId; // 현재 선택된 서비스의 ID

  // 서비스 선택 및 모달 호출 처리
  void _selectServiceAndShowModal(String serviceId, int? salonCategoryId, String price, String service) {
    setState(() {
      _selectedServiceId = serviceId;
    });

    // 선택된 salonCategoryId 업데이트
    ref
        .read(salonCategoryProvider.notifier)
        .setSalonCategoryId(int.parse(serviceId));

    ref.read(selectedServiceIdProvider.notifier).state = int.parse(serviceId);

    ref.read(selettedServiceNameProvider.notifier).state = service;
    

    bookingNextModal(context, price); // 모달 표시
  }

  @override
  Widget build(BuildContext context) {
    final userSelection = ref.watch(userSelectionProvider);
    final selectedGender = userSelection.selectedGender;
    final selectedCategoryId = userSelection.selectedCategoryId;
    String uniqueKey = "${selectedGender}_${selectedCategoryId}";

    final servicesAsyncValue = ref.watch(servicesProvider(uniqueKey));

    return servicesAsyncValue.when(
      data: (services) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final formattedPrice = NumberFormat('#,###', 'ko_KR')
                  .format(int.parse(service.price ?? '0')) +
              'salon.salonBooking.currency'.tr();
          final serviceName = service.service ?? "Unknown Service";

          return InkWell(
            splashColor: Palette.backgroundColor.withOpacity(0.0),
            highlightColor: Palette.backgroundColor.withOpacity(0.0),
            hoverColor: Palette.backgroundColor.withOpacity(0.0),
            onTap: () => {
              _selectServiceAndShowModal(
                  service.id.toString(), service.salonCategoryId, formattedPrice, serviceName),
              debugPrint('${ref.read(salonCategoryProvider)}')
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Palette.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Radio<String>(
                    activeColor: Palette.mainColor,
                    value: service.id.toString(),
                    groupValue: _selectedServiceId,
                    onChanged: (value) => _selectServiceAndShowModal(
                        service.id.toString(), service.salonCategoryId, formattedPrice, serviceName),
                  ),
                  Expanded(
                    child: Text(
                      service.service ?? "Unknown Service",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Text(
                    formattedPrice,
                    style: TextStyle(color: Palette.mainColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: CircularProgressIndicator(color: Palette.stateColor4),
        ),
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
