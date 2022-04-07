import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallerycubit/bloc/gallery_cubit.dart';
import 'package:gallerycubit/widget/image_controller_widget.dart';
import 'package:gallerycubit/widget/image_widget.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

const double minScale = 1;
const double defScale = 0.4;
const double maxScale = 5;

class _EditScreenState extends State<EditScreen> {
  double _rotation = 0;
  BoxShape shape = BoxShape.rectangle;
  final controller = CropController(
    aspectRatio: 1000 / 667.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(body: BlocBuilder<GalleryCubit, GalleryState>(
      builder: (context, state) {
        switch (state.status) {
          case GalleryStatus.loaded:
            return Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: height * 0.90,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: BlocBuilder<GalleryCubit, GalleryState>(
                      builder: (context, state) {
                    switch (state.status) {
                      case GalleryStatus.loaded:
                        return Column(
                          children: [
                            EditOptionWidget(
                              optionTitle: 'Edit Photos',
                              iconData: Icons.close,
                              onClick: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),

                            // image edit buttons
                            ImageEditOptionButton(),
                            // image screen
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Crop(
                                    onChanged: (decomposition) {
                                      // if (_rotation != decomposition.rotation) {
                                      //   setState(() {
                                      //     _rotation =
                                      //         ((decomposition.rotation + 180) %
                                      //                 360) -
                                      //             180;
                                      //   });
                                      // }
                                    },
                                    controller: controller,
                                    padding: EdgeInsets.zero,
                                    dimColor: Colors.white,
                                    shape: shape,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      'assets/images/sample.jpg',
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                    ),
                                    // foreground: IgnorePointer(
                                    //   child: Container(
                                    //     alignment: Alignment.bottomRight,
                                    //     child: const Text(
                                    //       'Foreground Object',
                                    //       style: TextStyle(color: Colors.red),
                                    //     ),
                                    //   ),
                                    // ),
                                    helper: shape == BoxShape.rectangle
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          )
                                        : null,
                                  )),
                            ),
                            // slider section
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (controller.scale > 1) {
                                            controller.scale =
                                                controller.scale - 1;
                                          }
                                        });
                                      },
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: const Icon(Icons.minimize)),
                                    ),
                                    Slider(
                                      value: controller.scale,
                                      min: 1,
                                      max: 100,
                                      activeColor: Colors.black54,
                                      // inactiveColor: Colors.black45,
                                      thumbColor: const Color(0XFF4CB8AC),
                                      onChanged: (double newScale) {
                                        setState(() {
                                          controller.scale = newScale;
                                        });
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (controller.scale < 100) {
                                            controller.scale =
                                                controller.scale + 1;
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // horizontal image section
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: state.galleryImages.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            BlocProvider.of<GalleryCubit>(
                                                    context)
                                                .setSelectedObjectIndex(index);
                                          },
                                          child: ImageWidget(
                                              index: index,
                                              height: 100,
                                              width: 120,
                                              path: state.galleryImages[index]
                                                  .filePath),
                                        )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: InkWell(
                                onTap: _cropImage,
                                child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: const Color(0XFF4CB8AC),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Text('SAVE',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )),
                              ),
                            )
                          ],
                        );
                      case GalleryStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return Center(
                          child: Text('somethig went woring'),
                        );
                    }
                  }),
                ),
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
    ));
  }
}

class ImageEditOptionButton extends StatelessWidget {
  const ImageEditOptionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageEditButton(
            iconData: Icons.download,
            callBack: () {},
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageEditButton(
                  iconData: Icons.rotate_left,
                  callBack: () {
                    BlocProvider.of<GalleryCubit>(context)
                        .rotateAntiClockWise();
                  },
                ),
                ImageEditButton(
                  iconData: Icons.rotate_right,
                  callBack: () {
                    BlocProvider.of<GalleryCubit>(context).rotateClockWise();
                  },
                ),
                ImageEditButton(
                  iconData: Icons.delete,
                  callBack: () {
                    BlocProvider.of<GalleryCubit>(context)
                        .removeImageObjectFromList();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ImageEditButton extends StatelessWidget {
  const ImageEditButton({
    Key? key,
    this.callBack,
    this.iconData,
  }) : super(key: key);

  final VoidCallback? callBack;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callBack,
      child: Container(
        height: 45,
        width: 45,
        child: Icon(iconData),
        decoration: BoxDecoration(
            color: const Color(0XFFEBEBEB),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
