import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/widgets/conditions_hlist.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildConditionsBloc, ChildConditionsState>(
      builder: (context, state) {
        if (state.status == AppStatus.loading) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return Shimmer.fromColors(
                      child: const LoadingConditionHList(),
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.white);
                }),
          );
        }
        if (state.data != null) {
          return SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var condition = state.data[index];
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
                  }));
        }
        return const Center(child: Text('No data found'));
      },
    );
  }
}
