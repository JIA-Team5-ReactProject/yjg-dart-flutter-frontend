import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class AsImageViewDetail extends StatelessWidget {
  final List<String> imageUrls; // 이미지 URL 리스트

  const AsImageViewDetail({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '사진 상세보기'),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Center(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: imageUrls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageUrls[index]),
              initialScale: PhotoViewComputedScale.contained,
            );
          },
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          pageController: PageController(initialPage: 0),
        ),
      ),
    );
  }
}
