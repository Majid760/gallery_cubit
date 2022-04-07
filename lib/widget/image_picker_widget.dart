import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallerycubit/bloc/gallery_cubit.dart';

Future showImagePicker(context, {isReplaceImage = false}) async {
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: BlocBuilder<GalleryCubit, GalleryState>(
            builder: (BuildContext context, state) => Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 32,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text('Photo Library'),
                    onTap: () {
                      BlocProvider.of<GalleryCubit>(context)
                          .imgFromGallery(isReplaceImage: isReplaceImage);
                      Navigator.pop(context);
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    BlocProvider.of<GalleryCubit>(context)
                        .imgFromCamera(isReplaceImage: isReplaceImage);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
