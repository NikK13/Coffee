import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshView extends StatelessWidget {
  final Widget? child;
  final Function? updateCurrentDate;
  final ScrollController? scrollController;

  const RefreshView({
    Key? key,
    this.child,
    this.updateCurrentDate,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App.platform != "ios"
      ? RefreshIndicator(
        color: HexColor.fromHex(App.appColor),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: child,
        ),
        onRefresh: updateCurrentDate as Future<void> Function(),
      )
      : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: updateCurrentDate as Future<void> Function(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, _) => child,
              childCount: 1,
            ),
          )
        ],
      );
  }
}
