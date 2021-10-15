import 'package:flutter/material.dart';

class BurningTextWidget extends StatelessWidget {
  const BurningTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Burning Text')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              ShaderMask(
                shaderCallback: (bounds) {
                  return RadialGradient(
                      tileMode: TileMode.mirror,
                      radius: 1.0,
                      center: Alignment.topLeft,
                      colors: <Color>[
                        Colors.yellow,
                        Colors.deepOrange.shade900
                      ]).createShader(bounds);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Kasujja Muhammed',
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 1, fontSize: 20),
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 10,
                child: const Text('Button'),
              ),
              Stack(
                children: <Widget>[
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.black87],
                      ).createShader(bounds);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.asset(
                        'assets/meddie.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Kasujja Muhammed the greatest programmer in the country today',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
