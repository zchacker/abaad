// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showIcon;

  const HeaderWidget(this._height, this._showIcon, {Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState(_height, _showIcon);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final double _height;
  final bool _showIcon;
  IconData? _icon;

  _HeaderWidgetState(this._height, this._showIcon);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper:  ShapeClipper(
                [
                  Offset(width / 5, _height),
                  Offset(width / 10 * 5, _height - 60),
                  Offset(width / 5 * 4, _height + 20),
                  Offset(width, _height - 18)
                ]
            ),
            child: Container(
              decoration:  BoxDecoration(
                gradient:  LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    ],
                    begin:  const FractionalOffset(0.0, 0.0),
                    end: const  FractionalOffset(1.0, 0.0),
                    stops: const[0.0, 1.0],
                    tileMode: TileMode.clamp
                ),
              ),
            ),
          ),
          ClipPath(
            clipper:  ShapeClipper(
                [
                  Offset(width / 3, _height + 20),
                  Offset(width / 10 * 8, _height - 60),
                  Offset(width / 5 * 4, _height - 60),
                  Offset(width, _height - 20)
                ]
            ),
            child: Container(
              decoration:  BoxDecoration(
                gradient:  LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                ),
              ),
            ),
          ),
          ClipPath(
            clipper:  ShapeClipper(
                [
                  Offset(width / 5, _height),
                  Offset(width / 2, _height - 40),
                  Offset(width / 5 * 4, _height - 80),
                  Offset(width, _height - 20)
                ]
            ),
            child: Container(
              decoration:  BoxDecoration(
                gradient:  LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showIcon,
            child: SizedBox(
              height: _height - 40,
              child:  Center(
                child:Text('تأكيد البيانات', style: robotoBold.copyWith(fontSize: 24,color: Colors.white)),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height-20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(_offsets[0].dx, _offsets[0].dy, _offsets[1].dx,_offsets[1].dy);
    path.quadraticBezierTo(_offsets[2].dx, _offsets[2].dy, _offsets[3].dx,_offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}