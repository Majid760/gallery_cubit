import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallerycubit/bloc/gallery_cubit.dart';
import 'package:gallerycubit/screen/image_edit_screen.dart';
import 'package:gallerycubit/widget/editoption_bottom_widget.dart';
import 'package:gallerycubit/widget/header_widget.dart';
import 'package:gallerycubit/widget/image_picker_widget.dart';
import 'package:gallerycubit/widget/image_widget.dart';
import 'package:reorderables/reorderables.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListView(padding: const EdgeInsets.all(0), children: [
        const HeaderWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: BlocBuilder<GalleryCubit, GalleryState>(
              builder: (context, state) {
                switch (state.status) {
                  case GalleryStatus.loaded:
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReorderableWrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              runAlignment: WrapAlignment.center,
                              padding: const EdgeInsets.all(8),
                              children: state.galleryImages
                                  .asMap()
                                  .entries
                                  .map<Widget>((entry) {
                                int index = entry.key;
                                return InkWell(
                                  onTap: () {
                                    _showEditOption(context);
                                    BlocProvider.of<GalleryCubit>(context)
                                        .setSelectedObjectIndex(index);
                                  },
                                  child: SizedBox(
                                    height: 120,
                                    child: ImageWidget(
                                        path: state.galleryImages[index]
                                                ['filePath']
                                            .toString(),
                                        height: double.infinity / 2,
                                        width: 150,
                                        index: index),
                                  ),
                                );
                              }).toList(),
                              onReorder: (oldIndex, newIndex) =>
                                  BlocProvider.of<GalleryCubit>(context)
                                      .onReorder(oldIndex, newIndex),
                              onNoReorder: (int index) {
                                //this callback is optional
                              },
                              onReorderStarted: (int index) {
                                //this callback is optional
                                debugPrint(
                                    '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                              }),
                        ],
                      ),
                    );

                  case GalleryStatus.empty:
                    return const Center(
                      child: Text('no image! Please select image'),
                    );
                  default:
                    return const Center(child: Text('something went wrong!'));
                }
              },
            ),
          ),
        ),
      ]),
    ));
  }
}

void _showEditOption(context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return BlocBuilder<GalleryCubit, GalleryState>(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Wrap(runSpacing: 10, children: [
              Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: state.selectedIndex != 0 ? 200 : 160,
                    width: MediaQuery.of(context).size.width * .92,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            state.selectedIndex != 0
                                ? EditOptionWidget(
                                    optionTitle: 'Make Cover Photo',
                                    iconData: Icons.broken_image_outlined,
                                    onClick: () {
                                      BlocProvider.of<GalleryCubit>(context)
                                          .onReorder(state.selectedIndex!, 0);
                                      Navigator.pop(context);
                                    })
                                : const SizedBox(),
                            EditOptionWidget(
                              optionTitle: 'Edit',
                              iconData: Icons.border_color_outlined,
                              onClick: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const EditScreen(),
                                  ),
                                );
                              },
                            ),
                            EditOptionWidget(
                              optionTitle: 'Replace',
                              iconData: Icons.repeat,
                              onClick: () async {
                                await showImagePicker(context,
                                    isReplaceImage: true);
                                Navigator.pop(context);
                              },
                            ),
                            EditOptionWidget(
                              optionTitle: 'Delete',
                              iconData: Icons.delete_outlined,
                              onClick: () async {
                                await _showConfirmDialog(context);
                              },
                            )
                          ]),
                    )),
              ),
              Center(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                          child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Color(0XFF4CB8AC),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ))),
                ),
              ),
            ]),
          ),
        );
      });
}

// confirm dialog for deletion
Future _showConfirmDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
            child: Text('Image Deletion!', style: TextStyle(fontSize: 16))),
        content: const Text('Do you want to remove this image?',
            style: TextStyle(fontSize: 12)),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              BlocProvider.of<GalleryCubit>(context)
                  .removeImageObjectFromList();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
