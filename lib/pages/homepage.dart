import 'package:flutter/material.dart';
import 'package:image_upload/components/image_post.dart';
import 'package:image_upload/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override  
  void initState(){
    super.initState();
    fetchImages();
  }
  Future<void> fetchImages() async{
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(builder: (context, storageService, child){
      final List<String> imageUrls = storageService.imageUrls;
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: ()=>
        storageService.uploadImage(),
        child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index){
          final String imageUrl = imageUrls[index];
          return ImagePost(imageUrl: imageUrl);
        }),
      );
    }
    );
  }
}