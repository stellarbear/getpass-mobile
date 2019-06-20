import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/obscure.dart';
import 'package:getpass/src/infrastructure/service.dart';
import 'package:getpass/src/screens/main/modals/editServiceModal.dart';

class EditServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditServiceState();
}

class EditServiceState extends State<EditServicePage> {
  bool _filterShowing = false;

  @override
  Widget build(BuildContext context) {
    //  Clear filter on re-render
    serviceBloc.filterOnChange('');

    return Scaffold(
      appBar: AppBar(
        title: _filterShowing
            ? serviceFilter()
            : Text(i18n.get(at: I18n.EditServiceTitle)),
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
          serviceList(),
        ],
      ),
      floatingActionButton: addNewServiceButton(context),
    );
  }

  Widget addNewServiceButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final returnValue = await showDialog<Service>(
          context: context,
          builder: (BuildContext context) {
            serviceBloc.newServiceOnChange(
              Service.byDefault(),
            );

            return StreamBuilder(
              stream: serviceBloc.newServiceStream,
              builder: (context, newServiceSnapshot) {
                return editServiceModal(
                  context: context,
                  serviceSnapshot: newServiceSnapshot,
                  defaultService: Service.byDefault(),
                  serviceOnChange: serviceBloc.newServiceOnChange,
                  isNewService: true,
                );
              },
            );
          },
        );

        if (returnValue != null) {
          serviceBloc.serviceAdd(returnValue);
        }
      },
      child: Icon(Icons.add),
    );
  }

  Widget serviceFilter() {
    return StreamBuilder(
      stream: serviceBloc.filterStream,
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
            hintText: i18n.get(at: I18n.EditServiceFilterPlaceholder),
            hintStyle: TextStyle(
                color: Theme.of(context).primaryTextTheme.display1.color),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryTextTheme.display1.color),
            ),
            errorText: snapshot.error,
          ),
          onChanged: serviceBloc.filterOnChange,
        );
      },
    );
  }

  Widget serviceList() {
    return Flexible(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: serviceBloc.serviceStream,
          builder: (context, AsyncSnapshot<List<Service>> serviceListSnapshot) {
            return StreamBuilder(
              stream: serviceBloc.filterStream,
              builder: (context, filterSnapshot) {
                List<Service> filteredServiceList;

                if (!filterSnapshot.hasData || !serviceListSnapshot.hasData) {
                  filteredServiceList = List<Service>();
                } else {
                  filteredServiceList = serviceListSnapshot.data
                      .where((service) =>
                          service.value.startsWith(filterSnapshot.data))
                      .toList();

                  filteredServiceList
                      .sort((a, b) => a.value.compareTo(b.value));
                }

                return StreamBuilder(
                  stream: settingsBloc.settingsStream,
                  builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
                    if (!settingsSnapshot.hasData) {
                      return Text(i18n.get(at: I18n.Loading));
                    }

                    Settings settings = settingsSnapshot.data;
                    final obscureValue = settings.serviceVisibility;

                    if (!serviceListSnapshot.hasData ||
                        serviceListSnapshot.data.length == 0) {
                      return Card(
                        child: Center(
                          child: Text(
                            i18n.get(at: I18n.EditServiceAddFirst),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: filteredServiceList.length,
                            padding: EdgeInsets.all(4.0),
                            itemBuilder: (BuildContext context, int index) {
                              final Service currentService =
                                  filteredServiceList[index];

                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      serviceBloc.selectedServiceOnChange(
                                          currentService);
                                      Navigator.pop(context);
                                    },
                                    title: Text(obscure(
                                        currentService.value, obscureValue)),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () async {
                                            final returnValue =
                                                await showDialog<Service>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                serviceBloc.editServiceOnChange(
                                                    currentService);

                                                return StreamBuilder(
                                                  stream: serviceBloc
                                                      .editServiceStream,
                                                  builder: (context,
                                                      editServiceSnapshot) {
                                                    return editServiceModal(
                                                      context: context,
                                                      serviceSnapshot:
                                                          editServiceSnapshot,
                                                      serviceOnChange: serviceBloc
                                                          .editServiceOnChange,
                                                      defaultService:
                                                          currentService,
                                                      isNewService: false,
                                                    );
                                                  },
                                                );
                                              },
                                            );

                                            if (returnValue != null) {
                                              //serviceBloc.update
                                              serviceBloc.serviceRemove(
                                                  currentService);
                                              serviceBloc
                                                  .serviceAdd(returnValue);
                                              //serviceBloc.newServiceOnChange(
                                              //    Service.byDefault());
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          //tooltip: 'remove service',
                                          onPressed: () {
                                            serviceBloc
                                                .serviceRemove(currentService);
                                          },
                                        ),
                                      ],
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
