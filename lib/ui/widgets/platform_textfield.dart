import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/utils/app.dart';

class PlatformTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final bool showClear;
  final bool isExpanded;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final bool? enabled;
  final bool? isForNotes;
  final TextInputAction inputAction;

  const PlatformTextField({
    Key? key,
    required this.controller,
    required this.showClear,
    this.hintText,
    this.maxLines, this.minLines,
    this.inputType = TextInputType.name,
    this.isExpanded = false, this.enabled,
    this.isForNotes = false,
    this.inputAction = TextInputAction.done
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(App.platform != "ios"){
      return TextField(
        cursorColor: Colors.black,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        keyboardType: inputType,
        textInputAction: inputAction,
        enabled: enabled,
        expands: isExpanded,
        maxLines: maxLines,
        minLines: minLines,
        textAlignVertical: TextAlignVertical.top,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          suffixIcon: showClear ? GestureDetector(
            child: const Icon(
                CupertinoIcons.clear,
                color: Colors.black
            ),
            onTap: (){
              controller.clear();
              FocusScope.of(context).unfocus();
            },
          ) : const SizedBox(),
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: isForNotes! ? null :
          const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isForNotes! ? 8 : 30),
            borderSide: BorderSide(
              width:
              Theme.of(context).brightness == Brightness.dark ? 0 : 0.5,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isForNotes! ? 8 : 30),
            borderSide: BorderSide(
              width:
              Theme.of(context).brightness == Brightness.dark ? 0 : 0.5,
              style: BorderStyle.solid,
            ),
          ),
          focusColor: Colors.black,
          hoverColor: Colors.black,
        ),
        controller: controller,
      );
    }
    return CupertinoTextField(
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: App.font,
      ),
      textAlignVertical: TextAlignVertical.top,
      textCapitalization: TextCapitalization.sentences,
      prefix: isForNotes! ? null : const Padding(
        padding: EdgeInsets.only(left: 6),
        child: Icon(Icons.search, color: Colors.grey),
      ),
      suffix: showClear ? Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          child: const Icon(CupertinoIcons.clear, color: Colors.grey),
          onTap: (){
            controller.clear();
            FocusScope.of(context).unfocus();
          },
        ),
      ) : const SizedBox(),
      maxLines: maxLines,
      minLines: minLines,
      expands: isExpanded,
      keyboardType: inputType,
      textInputAction: inputAction,
      controller: controller,
      placeholder: hintText,
      placeholderStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          fontFamily: App.font
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width:
          Theme.of(context).brightness == Brightness.dark ? 0 : 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
    );
  }
}