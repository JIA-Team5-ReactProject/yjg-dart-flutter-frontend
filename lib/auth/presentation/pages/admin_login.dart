import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_button.dart";
import "package:yjg/auth/presentation/widgets/international_admin_login_form.dart";
import "package:yjg/shared/theme/theme.dart";

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var fontSize = screenSize.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: width * 0.3, bottom: height * 0.02),
                child: Image(
                  image: AssetImage('assets/img/yju_tiger_logo.png'),
                  width: width * 0.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.05),
                child: Image(
                    image: AssetImage('assets/img/yju_text_logo.png'),
                    width: width * 0.3),
              ),
              Text("login.admin.descriptionText", style: TextStyle(color: Palette.textColor.withOpacity(0.8), fontSize: fontSize * 0.035),).tr(),
              InternationalAdminLoginForm(),
              AuthTextButton(
                authText: "login.admin.textButton1".tr(),
                onPressed: () => {
                  Navigator.pushNamed(context, '/login_student'),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
