import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var imageFileList = <XFile>[].obs; // List untuk menyimpan gambar yang dipilih

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imageFileList.add(image); // Menambahkan gambar ke dalam daftar
    }
  }
}
