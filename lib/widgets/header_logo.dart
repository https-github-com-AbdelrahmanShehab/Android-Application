import 'package:flutter/material.dart';
import '../util/color.dart';

class HeaderLogo extends StatelessWidget {
  final Size deviceSize;
  HeaderLogo(this.deviceSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Baby\'s Cradle Monitor',
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 20,
              color: colorText,
            ),
          ),
          SizedBox(
            child: Image.asset('assets/image/cradle.png'),
            width: deviceSize.width*0.5,
            height: deviceSize.width*0.5,
          ),
        ],
      ),
    );
  }
}
