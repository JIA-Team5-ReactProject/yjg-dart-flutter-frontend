import "package:flutter/material.dart";

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;

    // title 매개변수 전달 여부에 따라 위젯을 다르게 생성
    if (title != null) {
      titleWidget = Text(
        title!,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          fontSize: 20,
        ),
      );
    } else {
      titleWidget = const Center(
        child: Image(
          image: AssetImage('assets/img/yju_logo.png'),
          width: 150,
        ),
      );
    }

    return AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
        ),
        actions: [
          // 알림창
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
        // 앱바 타이틀
        title: titleWidget,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
