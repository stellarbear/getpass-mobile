import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const kIcons = <Widget>[
      Icon(Icons.event),
      Icon(Icons.event),
      Icon(Icons.event),
      Icon(Icons.event)
    ];

    return DefaultTabController(
      length: kIcons.length,
      child: Builder(
        builder: (context) {
          final TabController controller = DefaultTabController.of(context);

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TabPageSelector(),
                Expanded(
                  child: IconTheme(
                    data: IconThemeData(
                        size: 128.0, color: Theme.of(context).accentColor),
                    child: TabBarView(
                      children: kIcons,
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text('back'),
                  onPressed: () {
                    final currentPageIndex = controller.index;
                    if (!controller.indexIsChanging && currentPageIndex > 0) {
                      controller.animateTo(currentPageIndex - 1);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('next'),
                  onPressed: () {
                    final currentPageIndex = controller.index;
                    if (!controller.indexIsChanging &&
                        currentPageIndex < kIcons.length - 1) {
                      controller.animateTo(currentPageIndex + 1);
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
