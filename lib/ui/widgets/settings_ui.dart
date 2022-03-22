import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/ui/widgets/ripple.dart';
import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final String? title;
  final String? trailing;
  final Function? onTap;
  final IconData? icon;
  final Widget? switchData;
  final bool? isFirst;
  final bool? isLast;

  const SettingsRow({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
    required this.icon,
    this.switchData,
    required this.isLast,
    required this.isFirst
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App.platform != "ios" ? Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: Ripple(
        radius: 16,
        rippleColor: Theme.of(context).brightness == Brightness.dark ?
        Colors.black26 : Colors.white,
        onTap: () => onTap!(),
        child: SizedBox(
          width: double.infinity,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: trailing != null ? 12 : 15,
              ),
              child:Row(
                children: [
                  Icon(
                    icon!,
                    size: 32,
                    color: HexColor.fromHex(App.appColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                        ),
                        if(trailing != null)
                        Text(
                          trailing!,
                          style: TextStyle(
                            fontSize: 14,
                            color: HexColor.fromHex(App.appColor),
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  if(switchData != null)
                  switchData!
                ],
              ),
            ),
          ),
        ),
      ),
    ) : GestureDetector(
      onTap: () => onTap!(),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if(icon != null)
                  Icon(
                    icon,
                    size: 22,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if(trailing != null)
                  Row(
                    children: [
                      Text(
                        trailing!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      )
                    ],
                  ),
                  if(switchData != null)
                  switchData!
                ],
              )
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withOpacity(0.5)
            ),
            borderRadius: BorderRadius.only(
              topLeft: isFirst! ? const Radius.circular(16) : Radius.zero,
              topRight: isFirst! ? const Radius.circular(16) : Radius.zero,
              bottomLeft: isLast! ? const Radius.circular(16) : Radius.zero,
              bottomRight: isLast! ? const Radius.circular(16) : Radius.zero,
            )
          ),
        ),
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String? title;

  const SettingsTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        title!,
        style: TextStyle(
          fontFamily: App.font,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: App.platform != "ios" ? 15 : 14,
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsRow>? settingsItems;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.settingsItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTitle(title: title),
        ListView.builder(
          itemCount: settingsItems!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return settingsItems![index];
          },
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}


