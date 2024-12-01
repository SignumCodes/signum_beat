import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/download/download_provider.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Ongoing Downloads", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: downloadProvider.progress.keys.length,
                itemBuilder: (context, index) {
                  String fileName = downloadProvider.progress.keys.elementAt(index);
                  double progress = downloadProvider.progress[fileName] ?? 0.0;
                  return ListTile(
                    title: Text(fileName),
                    subtitle: LinearProgressIndicator(value: progress),
                    trailing: Text("${(progress * 100).toStringAsFixed(0)}%"),
                  );
                },
              ),
            ),
            Divider(),
            Text("Recent Downloads", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: downloadProvider.recentDownloads.length,
                itemBuilder: (context, index) {
                  SongMetadata song = downloadProvider.recentDownloads[index];
                  return ListTile(
                    title: Text(song.fileName),
                    subtitle: Text("Artist: ${song.artist} - Album: ${song.album}"),
                    onTap: () {
                      // Code to play song or view file
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
