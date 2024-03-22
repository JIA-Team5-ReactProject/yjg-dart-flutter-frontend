import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/shared/service/auth_service.dart';

class BaseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Future<bool> getIsAdmin() async {
      final isAdmin = ref.watch(isAdminProvider);
      return isAdmin!;
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
                  onPressed: () {AuthService().logout(context, ref);}, 
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
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
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
