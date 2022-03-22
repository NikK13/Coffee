import 'package:coffee/data/utils/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final Color? color;

  const LoadingView({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App.platform == "ios"
    ?
    const CupertinoActivityIndicator()
    :
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color!),
    );
  }
}
