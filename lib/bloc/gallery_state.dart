part of 'gallery_cubit.dart';

enum GalleryStatus { empty, loading, loaded, unknown }

class GalleryState extends Equatable {
  const GalleryState(
      {this.status = GalleryStatus.loading,
      this.galleryImages = const [],
      this.picker,
      this.imageAngle,
      this.selectedIndex});
  final GalleryStatus status;
  final List<Map<String, dynamic>> galleryImages;
  final int? selectedIndex;
  final double? imageAngle;
  final ImagePicker? picker;

  GalleryState copyWith(
      {GalleryStatus? status,
      List<Map<String, dynamic>>? galleryImages,
      ImagePicker? picker,
      double? imageAngle,
      int? selectedIndex}) {
    return GalleryState(
        status: status ?? this.status,
        imageAngle: imageAngle ?? this.imageAngle,
        galleryImages: galleryImages ?? this.galleryImages,
        picker: picker ?? this.picker,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object?> get props =>
      [status, galleryImages, picker, selectedIndex, imageAngle];
}
