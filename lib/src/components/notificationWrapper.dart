import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:flutter/scheduler.dart';

Widget notificationWrapper({Widget child}) {
  return StreamBuilder(
    stream: notifyBloc.notifyStream,
    builder: (context, notifySnapshot) {
      bool shallNotify = notifySnapshot.hasData
          ? (notifySnapshot.data == null ? false : true)
          : false;

      if (shallNotify) {
        final _snackBar = SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(
            notifySnapshot.data,
            style: TextStyle(
                color: Theme.of(context).primaryTextTheme.display1.color),
          ),
          duration: Duration(seconds: 3),
        );

        SchedulerBinding.instance.addPostFrameCallback(
            (_) => Scaffold.of(context).showSnackBar(_snackBar));
        notifyBloc.notifyOnChange(null);
      }

      return child;
    },
  );
}
