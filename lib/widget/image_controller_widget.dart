import 'package:flutter/material.dart';

class EditOptionWidget extends StatelessWidget {
  const EditOptionWidget(
      {Key? key, this.optionTitle, this.iconData, this.onClick})
      : super(key: key);
  final String? optionTitle;
  final IconData? iconData;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          optionTitle!,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        ),
        InkWell(
          child: Icon(iconData),
          onTap: onClick,
        )
      ],
    );
  }
}
