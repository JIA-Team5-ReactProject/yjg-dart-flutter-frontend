import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:yjg/theme/palette.dart';

class BusDropdownButton extends StatefulWidget {
  final Function(String?) onSelected;
  const BusDropdownButton({super.key, required this.onSelected});

  @override
  State<BusDropdownButton> createState() => _BusDropdownState();
}

class _BusDropdownState extends State<BusDropdownButton> {
  final List<String> items = ['평일-영어출', '주말-영어출', '평일-복현출', '주말-복현출'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          '노선 선택',
          style: TextStyle(
            fontSize: 14,
            color: Palette.textColor,
          ),
        ),
        items: items.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 14, color: Palette.textColor),
          ),
        )).toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onSelected(value); // 콜백 함수 호출
        },
      ),
    );
  }
}
