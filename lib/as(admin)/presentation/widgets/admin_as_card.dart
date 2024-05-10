import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/as(admin)/data/models/as_list.dart';
import 'package:yjg/as(admin)/presentation/viewmodels/as_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class AdminAsCard extends ConsumerWidget {
  final AfterService asItem;

  const AdminAsCard({
    Key? key,
    required this.asItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
        height: 85.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Palette.stateColor4.withOpacity(0.5), width: 1.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            // id값 저장
            ref.read(serviceIdProvider.notifier).state = asItem.id;
            debugPrint('현제 선택된 AS ID: ${asItem.id}');
            Navigator.pushNamed(context, '/as_detail', arguments: asItem.id);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.handyman_outlined,
                color: asItem.status == 1 ? Palette.mainColor : Palette.stateColor3,
                size: 35.0,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      asItem.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.textColor.withOpacity(0.8),
                        letterSpacing: -0.5,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      '방문 예정일: ${asItem.visitDate}',
                      style: TextStyle(
                        color: Palette.stateColor4,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
              Text(
                asItem.status == 1 ? '처리완료' : '미처리',
                style: TextStyle(
                  color: asItem.status == 1 ? Palette.mainColor : Palette.stateColor3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
