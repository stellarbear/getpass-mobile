import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/components/numeric.dart';
import 'package:getpass/src/components/toggle.dart';
import 'package:getpass/src/infrastructure/service.dart';

Widget editServiceModal({
  BuildContext context,
  AsyncSnapshot<Service> serviceSnapshot,
  Function(Service) serviceOnChange,
  Service defaultService,
  bool isNewService,
}) {
  Service service =
      serviceSnapshot.hasData ? serviceSnapshot.data : defaultService;

  return AlertDialog(
    content: Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isNewService ? TextField(
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                hintText: i18n.get(at: I18n.AddNewServicePlaceholder),
                labelText: i18n.get(at: I18n.AddNewServiceText),
                errorText: serviceSnapshot.error,
                suffixIcon: Icon(Icons.cloud_circle),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryTextTheme.display1.color),
                ),
              ),
              onChanged: (value) => serviceOnChange(
                    service.copyWith(value: value),
                  ),
            ) : Text(service.value),
            Divider(),
            Toggle(
              value: service.number,
              onChange: (value) => serviceOnChange(
                    service.copyWith(number: value),
                  ),
              text: i18n.get(at: I18n.OptionNumbers),
            ),
            Toggle(
              value: service.upper,
              onChange: (value) => serviceOnChange(
                    service.copyWith(upper: value),
                  ),
              text: i18n.get(at: I18n.OptionUpperCase),
            ),
            Toggle(
              value: service.lower,
              onChange: (value) => serviceOnChange(
                    service.copyWith(lower: value),
                  ),
              text: i18n.get(at: I18n.OptionLowerCase),
            ),
            Toggle(
              value: service.special,
              onChange: (value) => serviceOnChange(
                    service.copyWith(special: value),
                  ),
              text: i18n.get(at: I18n.OptionSpecialChars),
            ),
            Divider(),
            Numeric(
              min: 1,
              max: 4096,
              value: service.length,
              onChange: (value) => serviceOnChange(
                    service.copyWith(length: value),
                  ),
              text: i18n.get(at: I18n.OptionPassLength),
            ),
            Numeric(
              min: 0,
              max: 4096,
              value: service.counter,
              onChange: (value) => serviceOnChange(
                    service.copyWith(counter: value),
                  ),
              text: i18n.get(at: I18n.OptionCounter),
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      FlatButton(
          child: Text(i18n.get(at: I18n.Cancel)),
          onPressed: () {
            Navigator.pop(context);
          }),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          i18n.get(at: I18n.OK),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: (!serviceSnapshot.hasError &&
                service.value.length > 0 &&
                (service.number ||
                    service.upper ||
                    service.lower ||
                    service.special))
            ? () {
                serviceOnChange(
                  Service.byDefault(),
                );
                Navigator.pop(
                  context,
                  service,
                );
              }
            : null,
      )
    ],
  );
}
