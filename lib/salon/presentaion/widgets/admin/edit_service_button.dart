import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:yjg/salon/presentaion/viewmodels/booking_select_id_viewmodel.dart';
import "package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart";
import "package:yjg/salon/presentaion/viewmodels/service_viewmodel.dart";
import "package:yjg/salon/presentaion/widgets/admin/edit_service_modal.dart";
import "package:yjg/salon/presentaion/widgets/booking_next_modal.dart";
import "package:yjg/shared/theme/palette.dart";
import 'package:intl/intl.dart';

class EditServiceButton extends ConsumerStatefulWidget {
  EditServiceButton({super.key, required this.uniqueKey});
  final String uniqueKey;

  @override
  _EditServiceButton createState() => _EditServiceButton();
}

class _EditServiceButton extends ConsumerState<EditServiceButton> {
  String? _selectedServiceId; // 현재 선택된 서비스의 ID

  void _selectServiceAndShowModal(
      String serviceId, int? salonCategoryId, String price, String service) {
    setState(() {
      _selectedServiceId = serviceId;
    });

    ref
        .read(salonCategoryProvider.notifier)
        .setSalonCategoryId(int.parse(serviceId));

    ref.read(selectedServiceIdProvider.notifier).state = int.parse(serviceId);

    ref.read(selettedServiceNameProvider.notifier).state = service;

    bookingNextModal(context, price);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final servicesAsyncValue = ref.watch(servicesProvider(widget.uniqueKey));

    return servicesAsyncValue.when(
      data: (services) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final formattedPrice =
              '${NumberFormat('#,###', 'ko_KR').format(int.parse(service.price ?? '0'))}원';
          final serviceName = service.service ?? "Unknown Service";
          return InkWell(
            splashColor: Palette.backgroundColor.withOpacity(0.0),
            highlightColor: Palette.backgroundColor.withOpacity(0.0),
            onTap: () => {
              editServiceModal(
                  context,
                  service.id.toString(),
                  service.salonCategoryId,
                  service.price.toString(),
                  serviceName,
                  service.gender!,
                  ref,
                  widget.uniqueKey),
              debugPrint('${ref.read(salonCategoryProvider)}'),
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              margin: EdgeInsets.only(bottom: 15.0),
              decoration: BoxDecoration(
                color: Palette.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      serviceName,
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
