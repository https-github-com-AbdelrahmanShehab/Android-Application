import 'package:flutter/material.dart';

import '../screens/camera_Screen.dart';

class CameraLiveItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(22, 22, 22, 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
                 GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CameraScreen.routeName);
                  },
                  child: Container(width: constraints.maxWidth*0.65, child: Image.asset('assets/image/live_streaming.png',)),
                ),
            FittedBox(
              child: Text(
                'Camera',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
