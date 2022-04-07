part of 'image_edit_cubit.dart';

enum ImageEditStatus {
  empty,
  loading,
  loaded,
  unknown,
}

class ImageEditState extends Equatable {
  const ImageEditState(
      {this.status,
      this.galleryCubit,
      this.photoController,
      this.scaleStateController,
      this.calls,
      this.minScale,
      this.maxScale,
      this.defScale});
  final ImageEditStatus? status;
  final GalleryCubit? galleryCubit;
  final int? calls;
  final double? minScale;
  final double? defScale;
  final double? maxScale;
  final PhotoViewControllerBase? photoController;
  final PhotoViewScaleStateController? scaleStateController;

  ImageEditState copyWith({
    ImageEditStatus? status,
    GalleryCubit? galleryCubit,
    PhotoViewControllerBase? photoController,
    PhotoViewScaleStateController? scaleStateController,
    int? calls,
    double? minScale,
    double? defScale,
    double? maxScale,
  }) {
    return ImageEditState(
        status: status ?? this.status,
        galleryCubit: galleryCubit ?? this.galleryCubit,
        photoController: photoController ?? this.photoController,
        scaleStateController: scaleStateController ?? this.scaleStateController,
        calls: calls ?? this.calls,
        minScale: minScale ?? this.minScale,
        maxScale: maxScale ?? this.maxScale,
        defScale: defScale ?? this.defScale);
  }

  @override
  List<dynamic> get props => [
        status,
        galleryCubit,
        photoController,
        scaleStateController,
        calls,
        minScale,
        defScale,
        maxScale
      ];
}
