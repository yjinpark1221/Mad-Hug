
import 'package:flutter/material.dart';

class SubjectListWidget extends StatefulWidget {

  State<SubjectListWidget> createState() => _SubjectListWidgetState();
}

class _SubjectListWidgetState extends State<SubjectListWidget> {
/// Will used to access the Animated list 
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  /// This holds the items
  List<int> _items = [];
  /// This holds the item count
  int counter = 0;
  Widget subjectTile(BuildContext context, int index, animation) {
    int item = _items[index];
    TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge;
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
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
    return AnimatedList(
      key: listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return subjectTile(context, index, animation); // Refer step 3
      },
    );
  }
}