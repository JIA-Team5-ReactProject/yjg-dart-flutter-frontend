import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/presentation/viewmodels/login_viewmodel.dart";
import "package:yjg/shared/service/auth_service.dart";

class BaseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();

    Future<void> checkUserState() async {
      if (!(await authService.isLoggedIn())) {
        debugPrint('토큰 미존재. 로그인 페이지로 이동');
        Navigator.pushNamed(context, '/login_student');
      } else {
        debugPrint('로그인 중');
      }
    }

    // initState 대신, ConsumerWidget에서는 addPostFrameCallback 내에서 직접 호출
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUserState());
    Widget titleWidget;
    bool? isAdmin = ref.watch(isAdminProvider);
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
      leading: isAdmin == true
          ? IconButton(
              onPressed: () => authService.logout(context, ref),
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
          : IconButton(
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
