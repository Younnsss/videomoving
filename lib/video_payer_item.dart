import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:videomoving/controller.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final int idx;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.idx,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  final Controller controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.videoPlayerController.value =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            controller.videoPlayerController.value!.play();
            controller.videoPlayerController.value!.setLooping(true);
          });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => controller.videoPlayerController.value == null
          ? SizedBox(
              width: 100,
              height: 100,
              child: const Center(
                child: Text('Drag me'),
              ),
            )
          : InkWell(
              onTap: () {
                if (controller.videoPlayerController.value!.value.isPlaying) {
                  controller.videoPlayerController.value!.pause();
                } else {
                  controller.videoPlayerController.value!.play();
                }
              },
              child: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    VideoPlayer(controller.videoPlayerController.value!),
                    Center(
                        child: Text(
                      widget.idx.toString(),
                    )),
                  ],
                ),
              ),
            ),
    );
  }
}
