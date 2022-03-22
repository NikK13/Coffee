import 'package:coffee/data/model/product.dart';
import 'package:coffee/data/repository/api_repository.dart';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/chips_list.dart';
import 'package:coffee/ui/widgets/errorreload.dart';
import 'package:coffee/ui/widgets/loading.dart';
import 'package:coffee/ui/widgets/platform_textfield.dart';
import 'package:coffee/ui/widgets/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SearchFragment extends StatefulWidget {
  final ScrollController? scrollController;
  final FavoritesBloc? favBloc;

  const SearchFragment({Key? key, this.scrollController, this.favBloc}) : super(key: key);

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  final _searchController = TextEditingController();
  late Future _placeData;

  int _selectedIndex = 0;
  String _filter = '';

  void Function(void Function())? _setSearchState, _setListState;

  @override
  void initState() {
    _placeData = ApiRepository.fetchProducts();
    _searchController.addListener(() {
      _setSearchState!(() {
        _filter = _searchController.text;
        _setListState!((){});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _placeData,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(!snapshot.hasData){
            return ErrorReloadView(
              color: HexColor.fromHex(App.appColor),
              reload: () => updateCurrentDate(),
            );
          }
          return buildView(snapshot.data);
        }
        return Center(
          child: LoadingView(
            color: HexColor.fromHex(App.appColor),
          ),
        );
      },
    );
  }

  setIndex(i) => setState(() => _selectedIndex = i);
  updateCurrentDate() async{
    setState(() {
      _placeData = ApiRepository.fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildView(List<Product> prods){
    final provider = Provider.of<PreferenceProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: RefreshView(
        updateCurrentDate: () async => await updateCurrentDate(),
        scrollController: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context, 'search'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: StatefulBuilder(
                  builder: (_, setItem){
                    _setSearchState = setItem;
                    return PlatformTextField(
                      controller: _searchController,
                      showClear: _filter.isNotEmpty,
                      enabled: true,
                      hintText: AppLocalizations.of(context, 'typehint'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10
                ),
                child: ChipsList(
                  index: _selectedIndex,
                  color: HexColor.fromHex(App.appColor),
                  func: (selected, index) {
                    if (selected) {
                      setIndex(index);
                    } else {
                      if (_filter.isEmpty) {
                        setIndex(index);
                      } else {
                        setIndex(0);
                      }
                    }
                  },
                ),
              ),
              StatefulBuilder(
                builder: (_, setItem) {
                  _setListState = setItem;
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: Product.getSearchList(_filter, prods, _selectedIndex, provider)!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = Product.getSearchList(_filter, prods, _selectedIndex, provider)![index];
                      return ProductItem(product: item, favBloc: widget.favBloc);
                    },
                    staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
