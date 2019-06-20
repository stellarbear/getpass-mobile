import 'package:flutter/material.dart';
import 'package:getpass/src/screens/main/tiles/generatePasswordTile.dart';
import 'package:getpass/src/screens/main/tiles/loginTile.dart';
import 'package:getpass/src/screens/main/tiles/secretsTile.dart';
import 'package:getpass/src/screens/main/tiles/serviceTile.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginTile(context),
        serviceTile(context),
        Divider(),
        secretsTile(context),
        Divider(),
        generatePasswordTile(context),
      ],
    );
  }
}