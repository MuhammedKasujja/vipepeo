import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class StackBottom extends StatelessWidget {
  const StackBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  width: 120,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                      //shape:
                      ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text("Join"),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 130,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                      //shape:
                      ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: Colors.grey,
                //       borderRadius: BorderRadius.all(Radius.circular(20.0))
                //       //shape:
                //       ),
                //   height: 140,
                //   width: 120,

                // ),
                Positioned(
                    bottom: -28,
                    right: 2,
                    left: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: const BoxDecoration(
                              color: AppTheme.PrimaryDarkColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text("Join"),
                            ),
                          )),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
