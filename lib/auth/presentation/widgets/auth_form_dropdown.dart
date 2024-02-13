import "package:flutter/material.dart";
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:yjg/shared/theme/palette.dart';

class AuthFormDropDown extends StatelessWidget {
  AuthFormDropDown({super.key, required this.dropdownCategory});
  String dropdownCategory;
  final List<String> genderItems = [
    '여자',
    '남자',
  ];

  final List<String> departmentItems = [
    '컴퓨터정보계열',
    'AI융합기계계열',
    '반도체전자계열',
    '신재생에너지전기계열',
    '국방군사계열',
    '건축과',
    '인테리어디자인과',
    '콘텐츠디자인과',
    '무인항공드론과',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Palette.mainColor, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Palette.stateColor4),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 0), 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    4), 
              ),
            ),
            hint: Text(
              dropdownCategory == "성별" ? "성별 선택" : "학과 선택",
              style: TextStyle(
                  fontSize: 14, color: Palette.textColor, letterSpacing: -0.5),
            ),
            items: (dropdownCategory == "성별" ? genderItems : departmentItems)
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Palette.textColor,
                            letterSpacing: -0.5),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (dropdownCategory == "성별" && value == null) {
                return '성별을 선택해 주세요.';
              }
              if (dropdownCategory == "학과" && value == null) {
                return '학과를 선택해 주세요.';
              }

              return null;
            },
            onChanged: (value) {},
            onSaved: (value) {
              selectedValue = value.toString();
            },
            buttonStyleData: const ButtonStyleData(
              height: 65.0,
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Palette.stateColor4,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}
