import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flare_flutter/flare_actor.dart';

class HyperLinkText extends TextSpan {
  HyperLinkText(
      {BuildContext context,
      TextStyle style,
      String url,
      String text,
      bool isEnabled = true})
      : super(
          style: Theme.of(context)
              .textTheme
              .caption
              .apply(color: Colors.blue.withOpacity(isEnabled ? 1.0 : 0.4)),
          text: text ?? url,
          recognizer: !isEnabled
              ? null
              : (TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
        );
}

Widget aboutModal(BuildContext context) {
  Widget welcome() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .apply(fontSizeFactor: 1.4),
                text: i18n.get(at: I18n.AboutTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget platformList() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            style: Theme.of(context).textTheme.body1,
            text: i18n.get(at: I18n.AboutPlatformTitle),
          ),
          HyperLinkText(
            context: context,
            url: 'https://github.com/stellarbear/getpass-spa',
            text: i18n.get(at: I18n.AboutWeb),
          ),
          HyperLinkText(
            context: context,
            url: 'https://github.com/stellarbear/getpass-extension',
            text: i18n.get(at: I18n.AboutBrowser),
          ),
          HyperLinkText(
            context: context,
            url: 'https://github.com/stellarbear/getpass-mobile',
            text: i18n.get(at: I18n.AboutMobile),
          ),
          HyperLinkText(
            context: context,
            url: 'https://github.com/stellarbear/getpass-desktop',
            text: i18n.get(at: I18n.AboutDesktop),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Center(
      child: FlareActor(
        "assets/animation/getpass.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Loading",
      ),
    );
  }

  Widget platforms() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: platformList(),
        ),
        Container(
          width: 80,
          height: 80,
          child: logo(),
        ),
      ],
    );
  }

  Widget tips() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            style: Theme.of(context).textTheme.body1,
            text: i18n.get(at: I18n.AboutTipsTitle),
          ),
          TextSpan(
            style: Theme.of(context).textTheme.caption,
            text: i18n.get(at: I18n.AboutTips),
          ),
          TextSpan(
            style: Theme.of(context).textTheme.caption,
            text: i18n.get(at: I18n.AboutAfterWord),
          ),
        ],
      ),
    );
  }

  Widget intro() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            style: Theme.of(context).textTheme.body1,
            text: i18n.get(at: I18n.AboutStepsTitle),
          ),
          TextSpan(
            style: Theme.of(context).textTheme.caption,
            text: i18n.get(at: I18n.AboutSteps),
          ),
        ],
      ),
    );
  }

  return AlertDialog(
    content: Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          welcome(),
          intro(),
          tips(),
          platforms(),
        ],
      ),
    ),
    actions: <Widget>[
      FlatButton(
          child: Text(i18n.get(at: I18n.Dismiss)),
          onPressed: () => Navigator.pop(context)),
    ],
  );
}
