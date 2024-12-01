import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  Widget? title;
  Widget? NormalText;
  double? size;
  Widget? leading;
  ShapeBorder? shape;
  Function()? onTap;
  CustomCard({
    this.title,
    this.size = 150,
    this.leading,
    this.NormalText,
    this.shape,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          // height: size!+50.h,
          width: size,
          child:Column(
            children: [
              Card(
                elevation: 10,
                shadowColor: Theme.of(context).primaryColor,
                shape:shape,
                clipBehavior: Clip.antiAlias,
                child: leading?? Image(image: NetworkImage('https://i.pinimg.com/originals/e5/e5/c1/e5e5c165395678ba1875abb4dc668292.png')),
              ),
              title??Container(),
              NormalText??Container()
            ],
          )
      ),
    );
  }
}
