import "package:flutter/material.dart";
import "package:yjg/shared/theme/palette.dart";

class AuthTextButton extends StatelessWidget {
  const AuthTextButton(
      {super.key, required this.authText, required this.onPressed});
  final String authText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Palette.stateColor4.withOpacity(0.1),
        ),
      ),
      child: Text(
        authText,
        style: TextStyle(
            color: Palette.mainColor,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2),
      ),
    );
  }
}
