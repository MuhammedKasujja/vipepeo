import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/widgets/conditions_hlist.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return SizedBox(
        height: 50,
        child: appState.childConditions != null
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: appState.childConditions.length,
                itemBuilder: (context, index) {
                  var condition = appState.childConditions[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Center(
                                child: Text(
                              condition.name,
                              style: const TextStyle(color: Colors.black54),
                            )),
                          ),
                        ),
                      ),
                      onTap: () {
                        print('Yes clicked');
                      },
                    ),
                  );
                })
            : ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return Shimmer.fromColors(
                      child: const LoadingConditionHList(),
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.white);
                }) //LoadingWidget(),
        );
  }
}
