import 'package:flutter/material.dart';
import 'package:gallerycubit/widget/image_picker_widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Photos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: const Color(0XFFEBEBEB),
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/images/info-italic.png',
                    height: 15,
                    width: 15,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () async {
                await showImagePicker(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0XFF4CB8AC)),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: Text(
                      'UPLOAD',
                      style: TextStyle(
                          color: Color(0XFF4CB8AC),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 16),
                    ),
                  )))),
        ],
      ),
    );
  }
}
