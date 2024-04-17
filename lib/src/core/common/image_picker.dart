// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  final ImagePicker picker;

  PickImage({
    required this.picker,
  });

  Future<XFile?> pickImageMobile({required ImageSource source}) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return null;
    }
  }
}

final pickProvider = Provider<PickImage>((ref) {
  return PickImage(picker: ImagePicker());
});
