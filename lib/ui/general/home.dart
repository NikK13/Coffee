import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/fragments/bookmarks.dart';
import 'package:coffee/ui/fragments/cart.dart';
import 'package:coffee/ui/fragments/explore.dart';
import 'package:coffee/ui/fragments/search.dart';
import 'package:coffee/ui/widgets/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _homeScrollC = ScrollController();
  final _searchScrollC = ScrollController();

  final _favBloc = FavoritesBloc();

  @override
  Widget build(BuildContext context) {
    App.setupBar(Theme.of(context).brightness == Brightness.light);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 10,
                  right: 10,
                  bottom: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      ExploreFragment(
                        reloadDesign: _reloadDesign,
                        scrollController: _homeScrollC,
                        favBloc: _favBloc,
                      ),
                      const CartFragment(),
                      SearchFragment(
                        scrollController: _searchScrollC,
                        favBloc: _favBloc,
                      ),
                      BookmarksFragment(
                        favBloc: _favBloc,
                      )
                    ],
                  ),
                )
              )
            ),
            BottomBar(
              color: Colors.grey,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).cardColor : Colors.white,
              shadowColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.transparent : Colors.grey.withOpacity(0.5),
              selectedColor: HexColor.fromHex(App.appColor),
              isWithTitle: true,
              iconSize: 26,
              onTabSelected: (int? index) {
                setState(() => _currentIndex = index!);
                if(index == 0) scrollToTheTop(_homeScrollC);
                if(index == 2) scrollToTheTop(_searchScrollC);
              },
              items: [
                BottomBarItem(
                  iconData: CupertinoIcons.home,
                  text: AppLocalizations.of(context, 'home'),
                ),
                BottomBarItem(
                  iconData: Icons.shopping_cart_outlined,
                  text: AppLocalizations.of(context, 'cart'),
                ),
                BottomBarItem(
                  iconData: App.platform == "ios" ?
                  CupertinoIcons.search : Icons.search,
                  text: AppLocalizations.of(context, 'search'),
                ),
                BottomBarItem(
                  iconData: App.platform == "ios" ?
                  CupertinoIcons.book : Icons.favorite_outline_rounded,
                  text: AppLocalizations.of(context, 'bookmarks'),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  void _reloadDesign(){
    setState(() {
      if(App.platform == "android"){
        App.platform = "ios";
      }
      else{
        App.platform = "android";
      }
    });
  }
}
