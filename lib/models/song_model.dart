import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  final String songId, title, artist, fileName, audio, albumCover, genre, uid;
  final DateTime createdAt;
  final List<String> writers, producers, languages, description;

  SongModel({
    required this.songId,
    required this.title,
    required this.artist,
    required this.fileName,
    required this.audio,
    required this.albumCover,
    required this.createdAt,
    required this.writers,
    required this.producers,
    required this.genre,
    required this.uid,
    required this.languages,
    required this.description,
  });

  static SongModel fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return SongModel(
      songId: snap.id,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      fileName: json['file_name'] ?? '',
      audio: json['audio'] ?? '',
      albumCover: json['album_cover'] ?? '',
      createdAt: json['created_at']?.toDate() ?? DateTime.now(),
      writers: (json['writers'] as List<dynamic>?)?.cast<String>() ?? [],
      producers: (json['producers'] as List<dynamic>?)?.cast<String>() ?? [],
      genre: json['genre'] ?? '',
      uid: json['uid'] ?? '',
      languages: (json['languages'] as List<dynamic>?)?.cast<String>() ?? [],
      description:
          (json['description'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> get json => {
        'songId': songId,
        'title': title,
        'artist': artist,
        'fileName': fileName,
        'audio': audio,
        'album_cover': albumCover,
        'createdAt': createdAt,
        'writers': writers,
        'producers': producers,
        'genre': genre,
        'uid': uid,
        'languages': languages,
        'description': description,
      };

  static Future<List<SongModel>> getSongs() async {
    List<SongModel> songs = [];
    await FirebaseFirestore.instance
        .collection('songs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        songs.add(SongModel.fromDocumentSnap(doc));
      }
    });

    return songs;
  }

  searchTitle(String song) {
    return title.toLowerCase().contains(song.toLowerCase());
  }
}
