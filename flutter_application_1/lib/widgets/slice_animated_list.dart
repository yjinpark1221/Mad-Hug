
import 'package:flutter/material.dart';

class SliceAnimatedList extends StatefulWidget {
  @override
  _SliceAnimatedListState createState() => _SliceAnimatedListState();
}

class _SliceAnimatedListState extends State<SliceAnimatedList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<int> _items = [];
  int counter = 0;

  Widget subjectTile(BuildContext context, int index, animation) {
    int item = _items[index];
    TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Center(
            child: Text('Item $item', style: textStyle),
          ),
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            height: double.infinity,
            child: AnimatedList(
              key: listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return subjectTile(context, index, animation);
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    listKey.currentState?.insertItem(0,
                        duration: const Duration(milliseconds: 500));
                    _items = []
                      ..add(counter++)
                      ..addAll(_items);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_items.length <= 1) return;
                  setState(() {
                    listKey.currentState?.removeItem(
                        0, (_, animation) => subjectTile(context, 0, animation),
                        duration: const Duration(milliseconds: 500));
                    _items.removeAt(0);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
