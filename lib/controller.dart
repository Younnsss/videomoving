import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

enum CardStatus { like, dislike }

class Controller extends GetxController {
  Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.value?.dispose();
  }

  final position = Offset.zero.obs;
  final isDragging = false.obs;

  void startPosition(DragStartDetails details) {
    isDragging.value = true;
  }

  void updatePosition(DragUpdateDetails details) {
    position.value += details.delta;
  }

  void endPosition(DragEndDetails details) {
    isDragging.value = false;
    print("position: ${position.value}");

    final state = getCardStatus();

    switch (state) {
      case CardStatus.like:
        videoPlayerController.value = VideoPlayerController.networkUrl(Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"))
          ..initialize().then((_) {
            videoPlayerController.value!.play();
            videoPlayerController.value!.setLooping(true);
          });
        break;
      case CardStatus.dislike:
        print("dislike");
        videoPlayerController.value!.dispose();
        videoPlayerController = Rx<VideoPlayerController?>(null);
        break;
      default:
        isDragging.value = false;
        position.value = Offset.zero;
    }

    position.value = Offset.zero;
  }

  CardStatus? getCardStatus() {
    const threshold = 50;

    if (position.value.dx > threshold) {
      return CardStatus.like;
    } else if (position.value.dx < -threshold) {
      return CardStatus.dislike;
    } else {
      return null;
    }
  }
}
