import 'package:coffee/data/model/product.dart';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/widgets/errorreload.dart';
import 'package:coffee/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BookmarksFragment extends StatelessWidget {
  final FavoritesBloc? favBloc;

  const BookmarksFragment({
    Key? key,
    this.favBloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context, 'bookmarks'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: favBloc!.listStream,
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                //debugPrint("${snapshot.connectionState}, ${snapshot.data}");
                if(snapshot.connectionState == ConnectionState.active){
                  if(snapshot.hasData){
                    if(snapshot.data!.isNotEmpty){
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ProductItem(
                            product: snapshot.data![index],
                            favBloc: favBloc,
                          );
                        },
                        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                      );
                    }
                    return const Center(child: Text("Empty bookmarks"));
                  }
                  return Center(
                    child: LoadingView(
                      color: HexColor.fromHex(App.appColor),
                    ),
                  );
                }
                return Center(
                  child: LoadingView(
                    color: HexColor.fromHex(App.appColor),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
