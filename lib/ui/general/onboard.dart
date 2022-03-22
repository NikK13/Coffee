import 'package:coffee/data/model/preferences.dart';
import 'package:coffee/data/model/slide.dart';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/platform_button.dart';
import 'package:coffee/ui/widgets/slide_dots.dart';
import 'package:coffee/ui/widgets/slide_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoard extends StatelessWidget {
  final Preferences? preferences;

  const OnBoard({Key? key, this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    App.setupBar(Theme.of(context).brightness == Brightness.light);
    return OnBoardScreen(prefs: preferences);
  }
}

class OnBoardScreen extends StatefulWidget {
  final Preferences? prefs;

  const OnBoardScreen({Key? key, this.prefs}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Future proceedToApp(context, provider) async {
    await provider
      ..savePreference('language', widget.prefs!.locale!.languageCode)
      ..savePreference('first', false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: 3,
                itemBuilder: (ctx, i) => SlideItem(
                  slideList: [
                    Slide(
                      sliderImage: 'assets/images/illustration1.png',
                      sliderHeading: AppLocalizations.of(ctx, 'onboard1_title'),
                      sliderSubHeading: AppLocalizations.of(ctx, 'onboard1_desc'),
                    ),
                    Slide(
                      sliderImage: 'assets/images/illustration2.png',
                      sliderHeading: AppLocalizations.of(ctx, 'onboard2_title'),
                      sliderSubHeading: AppLocalizations.of(ctx, 'onboard2_desc'),
                    ),
                    Slide(
                      sliderImage: 'assets/images/illustration3.png',
                      sliderHeading: AppLocalizations.of(ctx, 'onboard3_title'),
                      sliderSubHeading: AppLocalizations.of(ctx, 'onboard3_desc'),
                    ),
                  ],
                  index: i,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18
              ),
              child: Column(
                children: [
                  CircularProgress(
                    progress: progressByPage,
                    icon: _currentPage < 2 ?
                    Icons.arrow_forward_ios :
                    Icons.check,
                    onTap: () async{
                      if (_currentPage < 2) {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.linear,
                        );
                      }
                      else{
                        await proceedToApp(context, provider);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () async => await proceedToApp(context, provider),
                    child: Text(
                      AppLocalizations.of(context, 'skip'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.withOpacity(0.9)
                      ),
                    ),
                  ),
                  const SizedBox(height: 8)
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  double get progressByPage{
    switch(_currentPage){
      case 0:
        return 0;
      case 1:
        return 50;
      case 2:
        return 100;
      default:
        return 0;
    }
  }
}

class CircularProgress extends StatelessWidget {
  final double? progress;
  final IconData? icon;
  final Function? onTap;

  const CircularProgress({
    Key? key,
    this.progress,
    this.icon,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 80, height: 80,
          child: CircularProgressIndicator(
            value: progress! / 100,
            backgroundColor: Colors.grey.withOpacity(0.3),
            color: HexColor.fromHex(App.appColor),
            strokeWidth: 2.5,
          ),
        ),
        Positioned(
          top: 12, bottom: 12,
          right: 12, left: 12,
          child: GestureDetector(
            onTap: () => onTap!(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: HexColor.fromHex(App.appColor),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        )
      ],
    );
  }
}


