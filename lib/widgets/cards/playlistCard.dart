import 'package:signum_beat/utils/constants/const_var.dart';
import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
 final Widget? title;

  final double? size;
  final Widget? leading;
  final ShapeBorder? shape;
  final Function()? onTap;

  const PlaylistCard({
    this.title,
    this.size = 150,
    this.leading,
    this.shape,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          // height: size! + 40,
          width: size,
          child: Column(
            children: [
              Card(
                elevation: 10,
                shadowColor: Theme.of(context).primaryColor,
                shape: shape,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    leading ?? Image(image: NetworkImage(appImage)),
                    Positioned(
                      left: 5,
                        top: 5,
                        child: CircleAvatar(
                          radius: 10,
                      backgroundImage: NetworkImage(appImage),
                    )),
                  ],
                ),
              ),
              title ?? Container(),
            ],
          )),
    );
  }
}
