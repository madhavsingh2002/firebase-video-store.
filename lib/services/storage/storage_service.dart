import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier{
  final firebaseStorage = FirebaseStorage.instance;
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUploading;

  Future<void> fetchImages() async{
    _isLoading = true;
    final ListResult result = await firebaseStorage.ref('upload_images/').listAll();
    final urls = await Future.wait(result.items.map((ref)=> ref.getDownloadURL()));
    _imageUrls = urls;
    _isLoading = false;
    notifyListeners();
  }
  Future<void> deleteImages(String imageUrl) async{
    try{
      _imageUrls.remove(imageUrl);
      final String path = extractPathFromUrl(imageUrl);
      await firebaseStorage.ref(path).delete();
    }
    catch(e){
      print('Error Deleting Image: $e');
    }
    notifyListeners();
  }
  String extractPathFromUrl(String url){
    Uri uri = Uri.parse(url);
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }
  Future<void> uploadImage() async{
    _isLoading =true;
    notifyListeners();
    final ImagePicker picker  = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image==null){
      return;
    }
    File file = File(image.path);
    try{
      String filePath = 'upload_images/${DateTime.now()}.png';
      await firebaseStorage.ref(filePath).putFile(file);
      String downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();
      _imageUrls.add(downloadUrl);
      notifyListeners();
    }
    catch(e){
      print('Error uploading $e');
    }
    finally{
      _isUploading = false;
      notifyListeners();
    }
  }

}