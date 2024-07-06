import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:yjg/auth/domain/usecases/register_usecase.dart";
import "package:yjg/auth/domain/usecases/update_usecase.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/theme.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/base_drawer.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";

class UpdateAdmin extends ConsumerStatefulWidget {
  UpdateAdmin({Key? key}) : super(key: key);

  @override
  _UpdateAdmin createState() => _UpdateAdmin();
}

class _UpdateAdmin extends ConsumerState<UpdateAdmin> {
  static final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String? defaultName;
  String? defaultPhoneNumber;
  Map<String, dynamic> change = {};

  // 사용자 정보 가져오기(스토리지)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
  }

  // storage에서 isAdmin 값을 읽어와서 상태를 업데이트하는 메소드
  Future<void> getUserInfo() async {
    String? name = await storage.read(key: 'name');
    String? phoneNumber = await storage.read(key: 'phone_num');

    setState(() {
      defaultName = nameController.text = name!;
      defaultPhoneNumber = phoneNumberController.text = phoneNumber!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'information.update.title'.tr(),
      ),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.0,
            ),
            Icon(
              Icons.person,
              size: 30.0,
              color: Palette.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'registration.form.validatorText.formInvalid'.tr(),
                style: TextStyle(
                  fontSize: 15.0,
                  color: Palette.textColor,
                  letterSpacing: -0.5,
                ),
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
                          horizontal: 8, vertical: 16),
                      child: AuthTextFormField(
                        controller: nameController,
                        labelText: "informationUpdate.form.name".tr(),
                        validatorText: "informationUpdate.form.validatorText.name".tr(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: AuthTextFormField(
                        controller: phoneNumberController,
                        labelText: "전화번호",
                        validatorText: "전화번호를 입력해 주세요.",
                        inputFormatter: PhoneNumberInputFormatter(),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: AuthTextFormField(
                        controller: passwordController,
                        labelText: "현재 비밀번호",
                        validatorText: "비밀번호를 입력해 주세요.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: AuthTextFormField(
                        controller: newPasswordController,
                        labelText: "새 비밀번호",
                        validatorText: "비밀번호를 입력해 주세요.",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 22.0),
                      child: SizedBox(
                        width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
                        child: ElevatedButton(
                          onPressed: () async {
                            final updateUserInfoUseCase =
                                UpdateUserInfoUseCase(ref: ref);

                            // 이름 대조
                            if (defaultName != nameController.text) {
                              change['name'] = nameController.text;
                              await storage.write(
                                  key: 'name', value: nameController.text);
                            }
                            // 폰 번호 대조
                            if (defaultPhoneNumber !=
                                phoneNumberController.text) {
                              change['phone_num'] = phoneNumberController.text;
                              await storage.write(
                                  key: 'phone_num',
                                  value: phoneNumberController.text);
                            }
                            
                            // 그 외 비밀번호
                            if (passwordController.text.isNotEmpty) {
                              change['password'] = passwordController.text;
                            }
                            if (newPasswordController.text.isNotEmpty) {
                              change['new_password'] =
                                  newPasswordController.text;
                            }
                            debugPrint('변경된 값: $change');

                            await updateUserInfoUseCase.execute(
                              change: change,
                              context: context,
                            );
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
                          child: const Text(
                            '수정 완료',
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

// 기존 값 대조
void addChangeIfDifferent(String key, String defaultValue, String newValue,
    Map<String, dynamic> change) {
  if (defaultValue != newValue) {
    change[key] = newValue;
  }
}
