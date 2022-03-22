import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:flutter/material.dart';

class ChipsList extends StatelessWidget {
  final int? index;
  final Color? color;
  final Function? func;

  const ChipsList({
    Key? key,
    this.index, this.color, this.func
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];
    List _options = [
      AppLocalizations.of(context, 'all'),
      AppLocalizations.of(context, 'coffee'),
      AppLocalizations.of(context, 'tea'),
      AppLocalizations.of(context, 'dessert'),
    ];
    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: index == i,
        label: Container(
          padding: const EdgeInsets.only(
            bottom: 5, // Space between underline and text
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
              color: index == i ?
              HexColor.fromHex(App.appColor) :
              Colors.transparent,
              width: 2.5, // Underline thickness
            ))
          ),
          child: Text(
            _options[i],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        elevation: 0,
        pressElevation: 0,
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        onSelected: (bool selected) {
          func!(selected, i);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
      );
      chips.add(
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: choiceChip,
          ),
        ),
      );
    }
    return SizedBox(
      height: 50,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: chips,
      ),
    );
  }
}