import "package:flutter/material.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";
import 'package:photo_view/photo_view.dart';

class AsImageViewDetail extends StatelessWidget {
  final String imageUrl;

  const AsImageViewDetail({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '사진 상세보기',),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
      ),
      ),
    );
  }
}
