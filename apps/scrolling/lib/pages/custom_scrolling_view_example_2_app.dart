import 'package:flutter/material.dart';

class CustomScrollViewExample2App extends StatefulWidget {
  const CustomScrollViewExample2App({super.key});

  @override
  State<CustomScrollViewExample2App> createState() =>
      _CustomScrollViewExample2AppState();
}

class _CustomScrollViewExample2AppState
    extends State<CustomScrollViewExample2App> {
  List<int> top = <int>[];
  List<int> bottom = <int>[0];

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Press on the plus to add items above and below'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              top.add(-top.length - 1);
              bottom.add(bottom.length);
            });
          },
        ),
      ),
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.blue[200 + top[index] % 4 * 100],
                height: 100 + top[index] % 4 * 20.0,
                child: Text('Item: ${top[index]}'),
              );
            },
            childCount: top.length,
          )),
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.blue[200 + bottom[index] % 4 * 100],
                  height: 100 + bottom[index] % 4 * 20.0,
                  child: Text('Item: ${bottom[index]}'),
                );
              },
              childCount: bottom.length,
            ),
          )
        ],
      ),
    );
  }
}
