import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/widgets/platform_button.dart';
import 'package:flutter/material.dart';

class ErrorReloadView extends StatelessWidget {
  final Color? color;
  final Function? reload;

  const ErrorReloadView({
    Key? key,
    this.color, this.reload
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '😔${AppLocalizations.of(context, 'wrongerror')}😔',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          PlatformButton(
            onPressed: () async {
              try {
                await reload!();
              } catch (e) {
                debugPrint("ErrorOnClickReload: $e");
              }
            },
            text: "Try again",
          )
        ],
      ),
    );
  }
}
