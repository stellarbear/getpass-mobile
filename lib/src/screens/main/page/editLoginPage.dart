import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/obscure.dart';
import 'package:getpass/src/screens/main/modals/addLoginModal.dart';

class EditLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditLoginState();
}

class EditLoginState extends State<EditLoginPage> {
  bool _filterShowing = false;

  @override
  Widget build(BuildContext context) {
    //  Clear filter on re-render
    loginBloc.filterOnChange('');

    return Scaffold(
      appBar: AppBar(
        title: _filterShowing
            ? loginFilter()
            : Text(i18n.get(at: I18n.EditLoginTitle)),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(_filterShowing ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _filterShowing = !_filterShowing;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          loginList(),
        ],
      ),
      floatingActionButton: addNewLoginButton(context),
    );
  }

  Widget addNewLoginButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final returnValue = await showDialog<Login>(
          context: context,
          builder: (BuildContext context) {
            return StreamBuilder(
              stream: loginBloc.newLoginStream,
              builder: (context, newLoginSnapshot) {
                return addLoginModal(context, newLoginSnapshot);
              },
            );
          },
        );

        if (returnValue != null) {
          loginBloc.loginAdd(returnValue);
          loginBloc.newLoginOnChange(Login.byDefault());
        }
      },
      child: Icon(Icons.add),
    );
  }

  Widget loginFilter() {
    return StreamBuilder(
      stream: loginBloc.filterStream,
      builder: (context, snapshot) {
        return TextField(
          style: new TextStyle(
              color: Theme.of(context).primaryTextTheme.display1.color,
              fontSize: 18),
          autocorrect: false,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).highlightColor,
            hintText: i18n.get(at: I18n.EditLoginFilterPlaceholder),
            hintStyle: TextStyle(
                color: Theme.of(context).primaryTextTheme.display1.color),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryTextTheme.display1.color),
            ),
            errorText: snapshot.error,
          ),
          onChanged: loginBloc.filterOnChange,
        );
      },
    );
  }

  Widget loginList() {
    return Flexible(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: loginBloc.loginStream,
          builder: (context, AsyncSnapshot<List<Login>> loginListSnapshot) {
            return StreamBuilder(
              stream: loginBloc.filterStream,
              builder: (context, filterSnapshot) {
                List<Login> filteredLoginList;

                if (!filterSnapshot.hasData || !loginListSnapshot.hasData) {
                  filteredLoginList = List<Login>();
                } else {
                  filteredLoginList = loginListSnapshot.data
                      .where((login) =>
                          login.value.startsWith(filterSnapshot.data))
                      .toList();

                  filteredLoginList.sort((a, b) => a.value.compareTo(b.value));
                }

                return StreamBuilder(
                  stream: settingsBloc.settingsStream,
                  builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
                    if (!settingsSnapshot.hasData) {
                      return Text(i18n.get(at: I18n.Loading));
                    }

                    Settings settings = settingsSnapshot.data;
                    final obscureValue = settings.loginVisibility;

                    if (!loginListSnapshot.hasData ||
                        loginListSnapshot.data.length == 0) {
                      return Card(
                        child: Center(
                          child: Text(
                            i18n.get(at: I18n.EditLoginAddFirst),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: filteredLoginList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Login currentLogin =
                                  filteredLoginList[index];

                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      loginBloc
                                          .selectedLoginOnChange(currentLogin);
                                      Navigator.pop(context);
                                    },
                                    title: Text(obscure(
                                        currentLogin.value, obscureValue)),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        loginBloc.loginRemove(currentLogin);
                                      },
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
