import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/progress.dart';

class GenerationMockPage extends StatelessWidget {
  onCenter(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      );
  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(i18n.get(at: I18n.GenerationMockPageTitle)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          onBottom(
            StreamBuilder(
              stream: progressBloc.progressStream,
              builder: (context, AsyncSnapshot<double> progressSnapshot) {
                return progressSnapshot.hasData
                    ? Container(
                        margin: EdgeInsets.all(16.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Theme.of(context).accentColor,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          value: progressSnapshot.data,
                        ),
                      )
                    : Container();
              },
            ),
          ),
          onCenter(
            FlareActor(
              "assets/animation/getpass.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Loading",
            ),
          ),
        ],
      ),
    );
  }
}
