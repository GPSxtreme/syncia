import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_chat_controller.dart';
import '../models/image_room_message.dart';
import '../styles/size_config.dart';

class ImageFullScreenPage extends StatefulWidget {
  const ImageFullScreenPage({Key? key}) : super(key: key);

  @override
  State<ImageFullScreenPage> createState() => _ImageFullScreenPageState();
}

class _ImageFullScreenPageState extends State<ImageFullScreenPage> {
  final ImageRoomMessage message = ImageRoomMessage.fromMap(Get.arguments);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ImageChatController.to.saveImage(
                  message.imageLinks[_currentIndex],
                  message.imageLinks[_currentIndex].split('/').last);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: SizeConfig.screenHeight! * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.5,
                  child: PageView.builder(
                    itemCount: message.imageLinks.length,
                    onPageChanged: (val) => _currentIndex = val,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: message.imageLinks[index],
                        cacheKey: message.imageLinks[index].split('/').last,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: CircularProgressIndicator(
                                value: progress.progress),
                          );
                        },
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 15, right: 15, bottom: 40),
                  child: Text(
                    message.query,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
