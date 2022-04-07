import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallerycubit/bloc/gallery_cubit.dart';
import 'package:photo_view/photo_view.dart';

part 'image_edit_state.dart';

class ImageEditCubit extends Cubit<ImageEditState> {
  ImageEditCubit()
      : super(ImageEditState(
            status: ImageEditStatus.loaded,
            calls: 0,
            minScale: 1,
            maxScale: 5,
            defScale: 0.3,
            photoController: PhotoViewController(initialScale: 0.3)
              ..outputStateStream.listen((event) {
                event.scale;
              }),
            scaleStateController: PhotoViewScaleStateController()
              ..outputScaleStateStream.listen((event) {}))) {
    ;
  }

  void onController(PhotoViewControllerValue value) {
    emit(state.copyWith(
        calls: state.calls! + 1, status: ImageEditStatus.loaded));
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }
}
