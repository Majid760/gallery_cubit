import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallerycubit/model/Image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit()
      : super(GalleryState(
            galleryImages: const [],
            status: GalleryStatus.loaded,
            imageAngle: 0,
            picker: ImagePicker()));

  // getting image from gallery
  void imgFromGallery({isReplaceImage = false}) async {
    try {
      final images = (await state.picker?.pickMultiImage(imageQuality: 100));
      if (isReplaceImage && images != null) {
        final imageData = await _saveImageToLocalDirectory(images.last.path);
        if (imageData['isSuccess']) {
          replaceImage(state.selectedIndex!, imageData);
        }
      }
      if (images != null && !isReplaceImage) {
        for (var image in images) {
          await _saveImageToLocalDirectory(image.path);
        }
      }
    } catch (e) {
      emit(state.copyWith(
          galleryImages: [...state.galleryImages],
          status: GalleryStatus.loaded));
    }
  }

  // getting image from camera
  void imgFromCamera({isReplaceImage = false}) async {
    try {
      final image = (await state.picker?.pickImage(
          source: ImageSource.camera, maxWidth: 512, maxHeight: 512));
      if (isReplaceImage && image != null) {
        final imageData = await _saveImageToLocalDirectory(image.path);
        if (imageData['isSuccess']) {
          replaceImage(state.selectedIndex!, imageData);
        }
      }
      if (image != null && !isReplaceImage) {
        await _saveImageToLocalDirectory(image.path);
      }
    } catch (e) {
      emit(state.copyWith(
          galleryImages: [...state.galleryImages],
          status: GalleryStatus.loaded));
    }
  }

  Future<Map<String, dynamic>> _saveImageToLocalDirectory(String path) async {
    try {
      File imageFile = File(path);
      Uint8List imageByteData = imageFile.readAsBytesSync();
      Map<String, dynamic> savedImageData = {};
      final result = await ImageGallerySaver.saveImage(imageByteData,
          quality: 100, name: "new_mage.jpg");
      savedImageData['filePath'] =
          result['filePath'].toString().replaceAll(RegExp('file://'), '');
      savedImageData['isSuccess'] = result['isSuccess'];
      if (result['isSuccess']) {
        emit(state.copyWith(
            galleryImages: [...state.galleryImages, savedImageData],
            status: GalleryStatus.loaded));
        return result;
      } else {
        emit(state.copyWith(
            galleryImages: [...state.galleryImages],
            status: GalleryStatus.loaded));
        return result;
      }
    } on FileSystemException {
      throw Exception();
    } catch (e) {
      throw Exception(e);
    }
  }

  Image getImageObject(XFile? image) {
    Map<String, dynamic> imgObject = {};
    if (state.galleryImages.isEmpty) {
      imgObject = {
        'fileName': image!.name,
        'filePath': image.path,
        'isPrimaryPhoto': 1,
        'fileType': image.mimeType,
        'createdDate': DateTime.now().millisecondsSinceEpoch,
        'updatedDate': DateTime.now().millisecondsSinceEpoch
      };
    } else {
      imgObject = {
        'fileName': image!.name,
        'filePath': image.path,
        'isPrimaryPhoto': 0,
        'fileType': image.mimeType,
        'createdDate': DateTime.now().millisecondsSinceEpoch,
        'updatedDate': DateTime.now().millisecondsSinceEpoch
      };
    }

    return Image.fromJson(imgObject);
    imgObject;
  }

  // reordering the widget
  void onReorder(int oldIndex, int newIndex) {
    emit(state.copyWith(status: GalleryStatus.loading));
    List<Map<String, dynamic>> images = state.galleryImages;
    final dragElement = images.elementAt(oldIndex);
    final dropedElement = images.elementAt(newIndex);
    images.removeAt(newIndex);
    images.insert(newIndex, dragElement);
    images.removeAt(oldIndex);
    images.insert(oldIndex, dropedElement);
    emit(state.copyWith(
      galleryImages: images,
      selectedIndex: newIndex,
      status: GalleryStatus.loaded,
    ));
  }

  // replace the image
  void replaceImage(int replaceElementIndex, Map<String, dynamic> image) {
    emit(state.copyWith(status: GalleryStatus.loading));
    List<Map<String, dynamic>> listOfImages = state.galleryImages;
    listOfImages.removeAt(replaceElementIndex);
    listOfImages.insert(replaceElementIndex, image);
    emit(state.copyWith(
        galleryImages: [...listOfImages], status: GalleryStatus.loaded));
  }

  // set the selectedIndex
  void setSelectedObjectIndex(int index) {
    emit(state.copyWith(status: GalleryStatus.loading));
    emit(state.copyWith(
        status: GalleryStatus.loaded, selectedIndex: index, imageAngle: 0));
  }

  // remove the image from list
  void removeImageObjectFromList() {
    emit(state.copyWith(status: GalleryStatus.loading));
    int index = state.selectedIndex!;
    List<Map<String, dynamic>> listImagesObjects = state.galleryImages;
    listImagesObjects.removeAt(index);
    if (index == listImagesObjects.length) {
      emit(state.copyWith(
          galleryImages: [...listImagesObjects],
          selectedIndex: index == 0 ? 0 : index - 1,
          status: index == 0 ? GalleryStatus.empty : GalleryStatus.loaded));
    } else {
      emit(state.copyWith(
          galleryImages: [...listImagesObjects], status: GalleryStatus.loaded));
    }
  }

  // rotate the image
  void rotateClockWise() {
    double? degree = state.imageAngle;
    degree = degree! + (90 * math.pi / 180);
    emit(state.copyWith(imageAngle: degree, status: GalleryStatus.loaded));
  }

  void rotateAntiClockWise() {
    double? degree = state.imageAngle;
    degree = degree! + (-90 * math.pi / 180);
    emit(state.copyWith(imageAngle: degree, status: GalleryStatus.loaded));
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
