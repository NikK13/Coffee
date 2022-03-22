import 'package:flutter/material.dart';

class BottomBarItem {
  BottomBarItem({this.iconData, this.text});
  IconData? iconData;
  String? text;
}

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
    this.items,
    this.fontSize = 14.0,
    this.height = 55.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.onTabSelected,
    this.shadowColor,
    this.isWithTitle = false,
  }) : super(key: key);

  final double fontSize;
  final List<BottomBarItem>? items;
  final bool? isWithTitle;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? color;
  final Color? selectedColor;
  final ValueChanged<int?>? onTabSelected;

  @override
  State<StatefulWidget> createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<BottomBar> {
  int? _selectedIndex = 0;

  _updateIndex(int? index) {
    widget.onTabSelected!(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index],
        index: index,
        onPressed: _updateIndex,
        isWithTitle: widget.isWithTitle!,
      );
    });
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
        ),
        shadowColor: widget.shadowColor,
        color: widget.backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items,
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BottomBarItem item,
    int? index,
    ValueChanged<int?>? onPressed,
    required bool isWithTitle,
  }) {
    Color? color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onPressed!(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                if (isWithTitle)
                  Text(
                    item.text!,
                    style: TextStyle(
                      color: color,
                      fontSize: widget.fontSize,
                      fontWeight: _selectedIndex == index ? FontWeight.w700 : FontWeight.w400
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
