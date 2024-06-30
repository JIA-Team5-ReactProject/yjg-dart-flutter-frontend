import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/service/logout_service.dart';

class BaseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = FlutterSecureStorage();

    Future<bool> getIsAdmin() async {
      final isAdmin = await storage.read(key: 'isAdmin');
      return isAdmin == 'true';
    }

    Widget titleWidget = title != null
        ? Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
              fontSize: 20,
            ),
          )
        : const Center(
            child: Image(
              image: AssetImage('assets/img/yju_logo.png'),
              width: 150,
            ),
          );

    return FutureBuilder<bool>(
      future: getIsAdmin(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data ?? false;

        return AppBar(
          centerTitle: true,
          leading: isAdmin
              ? IconButton(
                  onPressed: () {
                    LogoutService().logout(context, ref);
                  },
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
            IconButton(
              onPressed: () {},
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.transparent,
                size: 30,
              ),
            ),
          ],
          title: titleWidget,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
