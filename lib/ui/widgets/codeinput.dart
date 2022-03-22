import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CodeInput extends StatefulWidget {
  final ValueChanged<String>? onCompleted;

  const CodeInput({
    Key? key,
    this.onCompleted,
  }) : super(key: key);

  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  final List<FocusNode> _listFocusNode = <FocusNode>[
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final _listControllerText = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int _currentIndex = 0;

  static final _form1 = GlobalKey<FormState>();
  static final _form2 = GlobalKey<FormState>();
  static final _form3 = GlobalKey<FormState>();
  static final _form4 = GlobalKey<FormState>();
  static final _form5 = GlobalKey<FormState>();
  static final _form6 = GlobalKey<FormState>();

  _getInputCode() {
    String verifycode = '';
    for (int i = 0; i < 6; i++) {
      for (int index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != ' ') {
          verifycode += _listControllerText[i].text[index];
        }
      }
    }
    return verifycode;
  }

  Widget _buildInputItem(index, context, key) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.black,
        width: Theme.of(context).brightness == Brightness.dark ? 0 : 0.5,
        style: BorderStyle.solid,
      ),
    );
    return TextField(
      key: key,
      keyboardType: TextInputType.number,
      maxLines: 1,
      maxLength: 2,
      focusNode: _listFocusNode[index],
      decoration: InputDecoration(
        focusedBorder: border,
        border: border,
        disabledBorder: border,
        enabledBorder: border,
        enabled: _currentIndex == index,
        counterText: "",
        contentPadding: const EdgeInsets.all(10),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (String value) {
        if (value.length > 1 && index < 6 || index == 0 && value.isNotEmpty) {
          if (index == 5) {
            widget.onCompleted!(_getInputCode());
            return;
          }
          if (_listControllerText[index + 1].value.text.isEmpty) {
            _listControllerText[index + 1].value = const TextEditingValue(text: " ");
          }
          _nextField(index);
          return;
        }
        if (value.isEmpty && index >= 0) {
          if (_listControllerText[index - 1].value.text.isEmpty) {
            _listControllerText[index - 1].value = const TextEditingValue(text: " ");
          }
          _previousField(index);
        }
      },
      controller: _listControllerText[index],
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: false,
      style: const TextStyle(fontSize: 24.0, color: Colors.black),
    );
  }

  void _nextField(int index) {
    if (index != 6) {
      setState(() => _currentIndex = index + 1);
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index + 1]);
      });
    }
  }

  void _previousField(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {
          _listControllerText[index - 1].text = ' ';
        }
        _currentIndex = index - 1;
      });
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index - 1]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double size = 40.0;
    final list = [_form1, _form2, _form3, _form4, _form5, _form6];
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _listFocusNode.map(
          (e) {
            final index = _listFocusNode.indexOf(e);
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: size / 10),
                child: _buildInputItem(index, context, list[index]),
              ),
            );
          },
        ).toList());
  }
}
