import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class FancyEvent extends StatelessWidget {
  const FancyEvent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: 10, //appState.suggestedEvents.length,
          itemBuilder: (context, index) {
            // var event = appState.suggestedEvents[index];
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Card(
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/meddie.jpg',
                                  ))),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 18,
                                )
                              ]),
                              width: 50,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8))),
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          '25',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ))),
                                  // Divider(),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8))),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text('APR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                      )))
                                ],
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child:
                                // ShaderMask(
                                //   shaderCallback: (bounds) {
                                //     return RadialGradient(
                                //         tileMode: TileMode.mirror,
                                //         radius: 1.0,
                                //         center: Alignment.topLeft,
                                //         colors: <Color>[
                                //           Colors.yellow,
                                //           Colors.deepOrange.shade900
                                //         ]).createShader(bounds);
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Text(
                                //       'Kasujja Muhammed',
                                //       style: TextStyle(
                                //           color: Colors.white,
                                //           letterSpacing: 1,
                                //           fontSize: 20),
                                //     ),
                                //   ),
                                // ),
                                ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return RadialGradient(
                                    tileMode: TileMode.mirror,
                                    radius: 1.0,
                                    center: Alignment.topLeft,
                                    colors: <Color>[
                                      Colors.yellow,
                                      Colors.deepOrange.shade900
                                    ]).createShader(bounds);
                              },
                              // child: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //       'This event is exceptional to u and me as well I love it how about u lady',
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold)),
                              // ),
                            )),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'This event is exceptional to u and me as well I love it how about u lady',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Mukono, Serena hotel',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Row(
                            children: <Widget>[
                              Chip(
                                label: const Text('9:00 am',
                                    style: TextStyle(
                                        color: AppTheme.PrimaryColor,
                                        fontWeight: FontWeight.bold)),
                                backgroundColor: Colors.green[100],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Chip(
                                padding: const EdgeInsets.all(2),
                                label: const Text(
                                  '2:00 pm',
                                  style: TextStyle(
                                      color: AppTheme.PrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.green[100],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
