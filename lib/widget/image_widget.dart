import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {Key? key,
      required this.path,
      this.index,
      this.height = double.infinity,
      this.width = double.infinity})
      : super(key: key);
  final String? path;
  final int? index;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  File(path!),
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                )),
            index == 0
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0XFF4CB8AC),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 30,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.done_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text('Primary Photo',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
