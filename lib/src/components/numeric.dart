import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Numeric extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChange;
  final String text;

  Numeric({Key key, this.value, this.min, this.max, this.onChange, this.text})
      : super(key: key);

  @override
  NumericState createState() => NumericState();
}

class NumericState extends State<Numeric> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.value.toString();
  }

  void updateValue(int newValue) {
    var cursorPos = controller.selection;
    if (cursorPos.start > controller.text.length) {
      cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: controller.text.length));
    }

    setState(() {
      controller.text = newValue.toString();
      controller.selection = cursorPos;
    });
    widget.onChange(newValue);
  }

  void updateUpperValue(int newValue) {
    widget.onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            int current = int.tryParse(controller.text);
            if (current == null) {
              current = widget.min;
            }
            if (current > widget.min) {
              updateValue(current - 1);
            }
          },
        ),
        Container(
          width: 40.0,
          child: TextField(
            controller: controller,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int result = int.tryParse(value);
              if (result == null) {
                updateUpperValue(widget.min);
              }
              if (result < widget.min) {
                updateValue(widget.min);
              } else if (result > widget.max) {
                updateValue(widget.max);
              } else {
                updateValue(result);
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            int current = int.tryParse(controller.text);
            if (current == null) {
              current = widget.min;
            }
            if (current < widget.max) {
              updateValue(current + 1);
            }
          },
        ),
        Text(widget.text),
      ],
    );
  }
}
