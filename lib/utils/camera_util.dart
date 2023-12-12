import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraUtil{
  // ImageSource imageSource;
  //
  // CameraUtil({required this.imageSource});


  CameraUtil();

  pick({onPick}) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if(image != null){
      onPick(File(image.path));
    }
    else{
      onPick(null);
    }
  }
}