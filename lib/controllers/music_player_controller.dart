import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

// void initState() {
//     player.playerStateStream.listen((playerState) async {
//       if (isPlaying != playerState.playing) {
//         isPlaying = playerState.playing;
//         notifyListeners();
//       }
//     });

//     player.durationStream.listen((newDuration) {
//       duration = newDuration ?? Duration.zero;
//       notifyListeners();
//     });

//     player.positionStream.listen((newPosition) {
//       position = newPosition;
//       notifyListeners();
//     });
//   }

  String time(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}