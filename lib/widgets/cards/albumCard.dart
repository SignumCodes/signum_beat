import  'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/albumProvider.dart';


class AlbumCard extends StatelessWidget {
  final String albumId;
  final double? size;
  final ShapeBorder? shape;
  final Function()? onTap;
  const AlbumCard({
    required this.albumId,
    this.size = 150,
    this.onTap,
    this.shape,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlbumProvider(id: albumId)..getAlbumData(),
      child: Consumer<AlbumProvider>(
        builder: (context, albumProvider, child) {
          if (albumProvider.isLoading) {
            return const Center(
              );
          }
          if (albumProvider.albumDetails == null) {
            return const Center(
                child: NormalText(text: 'No data available'),
            );
          }
          var data = albumProvider.albumDetails;
          return GestureDetector(
            onTap: onTap,
            child: SizedBox(
                height: size!+40,
                width: size,
                child:Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor,
                            blurRadius: 5,
                            spreadRadius:5,
                            offset: const Offset(0,5)
                          )
                        ]
                      ),
                      child: Image.network(data!.image!.first.link),

                    ),
                  /*  Card(
                      elevation: 10,
                      shape:shape,
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(data!.image!.first.link)?? Image(image: NetworkImage('https://i.pinimg.com/originals/e5/e5/c1/e5e5c165395678ba1875abb4dc668292.png')),
                    ),*/
                    NormalText(text: data.name)
                  ],
                )
            ),
          );
        },
      ),
    );

  }
}
