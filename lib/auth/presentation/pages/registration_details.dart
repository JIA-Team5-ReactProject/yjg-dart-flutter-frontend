import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/domain/usecases/detail_usecase.dart";
import "package:yjg/auth/domain/usecases/register_usecase.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/theme.dart";

class RegistrationDetails extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  Map<String, dynamic> change = {};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80.0,
            ),
            Icon(
              Icons.error_outline_rounded,
              size: 50.0,
              color: Palette.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'login.googleLogin.description'.tr(),
                style: TextStyle(fontSize: 18.0, color: Palette.textColor),
              ),
            ),

            // 폼 시작
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: AuthTextFormField(
                        controller: phoneNumberController,
                        labelText: "login.googleLogin.form.phoneNumber".tr(),
                        validatorText: "login.googleLogin.form.validatorText.phoneNumber".tr(),
                        inputFormatter: PhoneNumberInputFormatter(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: AuthTextFormField(
                        controller: studentIdController,
                        labelText: "login.googleLogin.form.studentNumber".tr(),
                        validatorText: "login.googleLogin.form.validatorText.studentNumber".tr(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 22.0),
                      child: SizedBox(
                        width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final detailUseCase = DetailUseCase(ref: ref);

                              String phoneNumber = phoneNumberController.text
                                  .replaceAll(RegExp(r'[^\d]'), '');

                              change = {
                                'phone_number': phoneNumber,
                                'student_id': studentIdController.text,
                              };

                              await detailUseCase.execute(
                                change: change,
                                context: context,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                    content: Text(
                                        'registration.form.validatorText.formInvalid'.tr()),
                                    backgroundColor: Palette.mainColor),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Palette.mainColor.withOpacity(0.8);
                              }
                              return Palette.mainColor;
                            }),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.8);
                              }
                              return Colors.white;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Palette.mainColor),
                              ),
                            ),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(100, 40)),
                          ),
                          child: Text(
                            'login.googleLogin.button'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
