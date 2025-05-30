import 'package:sandra/app/core/importer.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubePlayerController;
  bool isYoutubeVideo = false;

  @override
  void initState() {
    super.initState();
    isYoutubeVideo = widget.videoUrl.contains('youtube.com') ||
        widget.videoUrl.contains('youtu.be');
    if (isYoutubeVideo) {
      _initializeYoutubePlayer();
    } else {
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: true,
    );
    setState(() {});
  }

  void _initializeYoutubePlayer() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isYoutubeVideo
        ? YoutubePlayer(
            controller: _youtubePlayerController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            thumbnail: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                TablerIcons.player_play,
                color: Colors.white,
                size: 40,
              ),
            ),
          )
        : _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
  }
}
