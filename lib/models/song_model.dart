import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  final String songId, title, fileName, audio, albumCover;
  final DateTime createdAt;
  final List<String> writers;

  SongModel({
    required this.songId,
    required this.title,
    required this.fileName,
    required this.audio,
    required this.albumCover,
    required this.createdAt,
    required this.writers,
  });

  static SongModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return SongModel(
      songId: snap.id,
      title: json['title'] ?? '',
      fileName: json['file_name'] ?? '',
      audio: json['audio'] ?? '',
      albumCover: json['album_cover'] ?? '',
      createdAt: json['created_at']?.toDate() ?? DateTime.now(),
      writers: (json['writers'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> get json => {
        'songId': songId,
        'title': title,
        'fileName': fileName,
        'audio': audio,
        'album_cover': albumCover,
        'createdAt': createdAt,
        'writers': writers,
      };
}
