import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentsController extends GetxController {
  Rxn<XFile> licenseFile = Rxn<XFile>();
  Rxn<XFile> titleFile = Rxn<XFile>();

  void pickDocument(String type, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      if (type == 'license') {
        licenseFile.value = picked;
      } else if (type == 'title') {
        titleFile.value = picked;
      }
    }
  }

  void clearDocument(String type) {
    if (type == 'license') {
      licenseFile.value = null;
    } else if (type == 'title') {
      titleFile.value = null;
    }
  }

  bool get hasAtLeastOne =>
      licenseFile.value != null || titleFile.value != null;
}
