import 'package:flutter/material.dart';
import 'package:image_upload/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class ImagePost extends StatelessWidget {
  final String imageUrl;
  ImagePost({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
        builder: (context, storageService, child) => Container(
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => storageService.deleteImages(imageUrl),
                      icon: const Icon(Icons.delete)),
                  Image.network(imageUrl,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProcess){
                    if(loadingProcess!=null){
                      return SizedBox(
                        height: 300,
                        child: Center(child: 
                        CircularProgressIndicator(
                          value: loadingProcess.expectedTotalBytes != null 
                          ? loadingProcess.cumulativeBytesLoaded / 
                          loadingProcess.expectedTotalBytes! : null
                        )),
                      );
                    }
                    else{
                      return child;
                    }
                  },)
                ],
              ),
            ));
  }
}
