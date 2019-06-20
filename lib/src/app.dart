import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/components/firstLaunchWrapper.dart';
import 'package:getpass/src/components/notificationWrapper.dart';
import 'package:getpass/src/components/themeBuilder.dart';
import 'package:getpass/src/screens/main/page/editLoginPage.dart';
import 'package:getpass/src/screens/main/page/editServicePage.dart';
import 'package:getpass/src/screens/main/mainScreen.dart';
import 'package:getpass/src/screens/main/page/generationMockPage.dart';
import 'package:getpass/src/screens/settings/settingsScreen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tabPages = <Widget>[
      MainScreen(),
      SettingsScreen(),
      //TutorialScreen(),
    ];

    //  For custom tab width use the following pattern:
    /*
      Tab(
        child: Container(
          width: 40.0,
          child: Icon(Icons.help, color: Colors.white),
        ),
      ),

      And do not forget to add "isScrollable: true" to TabBar
    */

    final _tabs = <Tab>[
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.vpn_key, color: Colors.white),
            Text(i18n.get(at: I18n.MainTab),
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.settings, color: Colors.white),
            Text(i18n.get(at: I18n.SettingsTab),
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    ];
    return StreamBuilder(
      stream: colorThemeBloc.colorStream,
      builder: (context, AsyncSnapshot<ColorTheme> colorSnapshot) {
        
        ColorTheme colorTheme =
            colorSnapshot.hasData ? colorSnapshot.data : ColorTheme.byDefault();
        final autoBrightness = colorTheme.autoBrightness;
        if (autoBrightness) {
          colorTheme.adjustBrightness();
        }

        return MaterialApp(
          //showPerformanceOverlay: true,
          theme: themeBuilder(colorTheme: colorTheme),
          home: DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  titleSpacing: 1,
                  bottom: TabBar(tabs: _tabs),
                ),
              ),
              body: firstLaunchWrapper(
                child: notificationWrapper(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: _tabPages,
                  ),
                ),
              ),
            ),
          ),
          title: i18n.get(at: I18n.AppTitle),
          onGenerateRoute: routes,
        );
      },
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/edit/login':
        return MaterialPageRoute(
          builder: (context) {
            return EditLoginPage();
          },
        );
      case '/edit/service':
        return MaterialPageRoute(
          builder: (context) {
            return EditServicePage();
          },
        );
      case '/loading':
        return MaterialPageRoute(
          builder: (context) {
            return GenerationMockPage();
          },
        );
      case '/':
      case '/generatePassword':
      default:
        return MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        );
    }
  }
}
