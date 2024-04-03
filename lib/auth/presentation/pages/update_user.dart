import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/domain/usecases/register_usecase.dart";
import "package:yjg/auth/domain/usecases/update_usecase.dart";
import "package:yjg/auth/presentation/viewmodels/user_viewmodel.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/theme.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/base_drawer.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";

class UpdateUser extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    TextEditingController nameController =
        TextEditingController(text: user.name);
    TextEditingController phoneNumberController =
        TextEditingController(text: user.phoneNumber);
    TextEditingController studentIdController =
        TextEditingController(text: user.studentId);

    TextEditingController newPasswordController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: BaseAppBar(
        title: '개인정보 수정',
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
              child: const Text(
                '빈칸 없이 모든 정보를 입력해 주세요.',
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
                        labelText: "이름",
                        validatorText: "이름을 입력해 주세요.",
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
                        controller: studentIdController,
                        labelText: "학번",
                        validatorText: "학번을 입력해 주세요.",
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
                            if (_formKey.currentState!.validate()) {
                              final updateUserInfoUseCase =
                                  UpdateUserInfoUseCase(ref: ref);

                              String phoneNumber = phoneNumberController.text
                                  .replaceAll(RegExp(r'[^\d]'), '');

                              await updateUserInfoUseCase.execute(
                                name: nameController.text,
                                phoneNumber: phoneNumber,
                                studentId: studentIdController.text,
                                newPassword: newPasswordController.text,
                                password: passwordController.text,
                                context: context,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('입력되지 않은 필드가 있습니다. 다시 한 번 확인해 주세요.'),
                                  backgroundColor: Colors.red,
                                ),
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
