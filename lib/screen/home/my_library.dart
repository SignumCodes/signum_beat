/*import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';

class LibrarySong extends StatelessWidget {
  LibrarySong({super.key,});

  Dio _dio = Dio();
  Uint8List? _audioBytes;
  // final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 55,
            child: const ListTile(
              title: Text("Shuffle playback"),
              leading: Icon(Icons.play_circle),
              trailing: Icon(Icons.shuffle),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // or another loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('No data available'); // Handle the case where data is null
                } else {

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      return Container(
                        margin:  EdgeInsets.all(4),
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            id: data.id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget:  Icon(
                              Icons.music_note,
                              size: 32,
                            ),
                          ),
                          title: Text(data.displayNameWOExt),
                          subtitle: Text(snapshot.data![index].artist??''),
                          trailing: Wrap(
                            spacing: 8.0,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Share.shareUri(Uri.parse(snapshot.data![index].uri!));
                                },
                                icon: Icon(Icons.share),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                          onTap: (){
                            // controller.playSong(snapshot.data![index], index);
                            // UniVar.data =snapshot.data!;
                            // UniVar.addRecentSong(snapshot.data![index]);
                            // // BottomSheetPlayer.showBottomSheet(context,UniVar.data);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:file_picker/file_picker.dart';

class LibrarySong extends StatefulWidget {
  @override
  _LibrarySongState createState() => _LibrarySongState();
}

class _LibrarySongState extends State<LibrarySong> {
  AudioMetadata? _metadata;

  Future<void> pickAudioAndReadMetadata() async {
    // Use a file picker to select an audio file
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        // Read metadata from the audio file
        final metadata = await readMetadata(file);
        setState(() {
          _metadata = metadata;
        });
      } catch (e) {
        print('Error reading metadata: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Metadata Reader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickAudioAndReadMetadata,
              child: Text('Pick Audio File'),
            ),
            SizedBox(height: 20),
            _metadata != null
                ? Text(
              'Metadata:\n${_metadata.toString()}',
              textAlign: TextAlign.center,
            )
                : Text('No metadata available'),
          ],
        ),
      ),
    );
  }
}
