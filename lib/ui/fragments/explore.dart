import 'package:coffee/data/model/product.dart';
import 'package:coffee/data/repository/api_repository.dart';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/appnavigator.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/main.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/general/profile.dart';
import 'package:coffee/ui/general/settings.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/photoavatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ExploreFragment extends StatefulWidget {
  final Function? reloadDesign;
  final ScrollController? scrollController;
  final FavoritesBloc? favBloc;

  const ExploreFragment({
    Key? key,
    this.reloadDesign,
    this.scrollController,
    this.favBloc
  }) : super(key: key);

  @override
  State<ExploreFragment> createState() => _ExploreFragmentState();
}

class _ExploreFragmentState extends State<ExploreFragment> {
  late Future _placesData;

  @override
  void initState() {
    _placesData = ApiRepository.fetchProducts(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: App.platform == "ios" ?
        const BouncingScrollPhysics() :
        const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context, 'home'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Row(
                  children: [
                    ProfilePhoto(
                      photo: provider.photo ?? "default",
                      onTap: (){
                        AppNavigator.of(context).push(const ProfilePage());
                      },
                    ),
                    const SizedBox(width: 18),
                    GestureDetector(
                      onTap: (){
                        AppNavigator.of(context).push(SettingsPage(
                          reloadDesign: widget.reloadDesign,
                        ));
                      },
                      child: Icon(
                        CupertinoIcons.settings,
                        size: 34,
                        color: HexColor.fromHex(App.appColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 36),
            Text(
              AppLocalizations.of(context, 'home_title'),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 48),
            FutureBuilder(
              future: _placesData,
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          " ${AppLocalizations.of(context, 'popular')}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductItem(
                              product: snapshot.data[index],
                              favBloc: widget.favBloc,
                            );
                          },
                          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }
                  return const SizedBox();
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
