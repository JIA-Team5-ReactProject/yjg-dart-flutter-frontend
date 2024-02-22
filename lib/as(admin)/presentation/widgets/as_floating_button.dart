import "package:flutter/material.dart";
import "package:flutter_speed_dial/flutter_speed_dial.dart";
import "package:yjg/as(admin)/presentation/widgets/as_writing_comment_modal.dart";
import "package:yjg/shared/theme/theme.dart";

class AsFloatingButton extends StatelessWidget {
  const AsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0, color: Colors.white),
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Palette.mainColor,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.chat, color: Colors.white),
            label: "댓글 작성",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15.0,
              letterSpacing: -1,
            ),
            backgroundColor: Palette.mainColor,
            labelBackgroundColor: Palette.mainColor,
            onTap: () {
              showAsWritingCommentModal(context);
            }),
        SpeedDialChild(
          child: const Icon(
            Icons.published_with_changes,
            color: Colors.white,
          ),
          label: "상태 변경",
          backgroundColor: Palette.mainColor,
          labelBackgroundColor: Palette.mainColor,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15.0,
              letterSpacing: -1),
          onTap: () {},
        )
      ],
    );
  }
}
