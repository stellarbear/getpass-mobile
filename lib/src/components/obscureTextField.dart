import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ObscureTextField extends StatefulWidget {
  final bool autofocus;
  final bool autocorrect;
  final String errorText;
  final String labelText;
  final Function(String) onChange;


  ObscureTextField(
      {this.onChange, this.errorText, this.labelText, this.autofocus = true, this.autocorrect = false, });

  @override
  ObscureTextFieldState createState() => ObscureTextFieldState();
}

class ObscureTextFieldState extends State<ObscureTextField> {
  bool obscure = true;
  IconData icon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
  }

  void updateState() {
    setState(() {
      obscure ^= true;
      icon = !obscure ? Icons.visibility : Icons.visibility_off;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: super.widget.autocorrect,
      autofocus: super.widget.autofocus,
      keyboardType: TextInputType.emailAddress,
      onChanged: super.widget.onChange,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        labelText: super.widget.labelText,
        errorText: super.widget.errorText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).primaryTextTheme.display1.color),
        ),
        suffix: InkWell(
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          onTap: updateState,
        ),
      ),
    );
  }
}
