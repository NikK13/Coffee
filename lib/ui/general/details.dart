import 'package:coffee/data/model/product.dart';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/appnavigator.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/cachedimage.dart';
import 'package:coffee/ui/widgets/loading.dart';
import 'package:coffee/ui/widgets/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final Product? product;
  final FavoritesBloc? favBloc;

  const ProductDetails({
    Key? key,
    this.product,
    this.favBloc
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _isLargeSize = false;

  @override
  Widget build(BuildContext context) {
    final halfHeight = MediaQuery.of(context).size.height / 2;
    final provider = Provider.of<PreferenceProvider>(context);
    App.setupBar(false);
    return WillPopScope(
      onWillPop: () async{
        App.setupBar(Theme.of(context).brightness == Brightness.light);
        return true;
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: widget.favBloc!.isLikedStream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if(snapshot.connectionState == ConnectionState.active){
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SizedBox(
                      height: halfHeight,
                      child: CachedImage(
                        url: widget.product!.image!,
                        radius: 0,
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 16,
                      child: GestureDetector(
                        onTap: (){
                          App.setupBar(Theme.of(context).brightness == Brightness.light);
                          AppNavigator.of(context).pop();
                        },
                        child: Icon(
                          App.platform == "ios" ?
                          Icons.arrow_back_ios :
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: halfHeight - 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? App.colorDark : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      provider.locale!.languageCode == "en" ?
                                      widget.product!.titleEng! : widget.product!.titleRus!,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async{
                                      await widget.favBloc!.changeLiked(
                                        snapshot.data! ? false : true,
                                      );
                                      snapshot.data! ?
                                      await widget.favBloc!.deleteProductByID(widget.product!.id!) :
                                      await widget.favBloc!.addProduct(widget.product!);
                                      await widget.favBloc!.getAllData();
                                      debugPrint("${snapshot.data}");
                                    },
                                    child: Icon(
                                      snapshot.data! ?
                                      Icons.favorite :
                                      Icons.favorite_outline,
                                      size: 32,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if(widget.product!.type == "Coffee" || widget.product!.type == "Tea")
                                      Column(
                                        children: [
                                          const SizedBox(height: 16),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                " Size:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ProductSize(
                                                    title: "S",
                                                    isSelected: !_isLargeSize,
                                                    onTap: (){
                                                      setState(() {
                                                        _isLargeSize = false;
                                                      });
                                                    },
                                                  ),
                                                  ProductSize(
                                                    title: "L",
                                                    isSelected: _isLargeSize,
                                                    onTap: (){
                                                      setState(() {
                                                        _isLargeSize = true;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        provider.locale!.languageCode == "en" ?
                                        widget.product!.descEng! : widget.product!.descRus!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Price:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "${getRealPrice(
                                          widget.product!.price!,
                                          widget.product!.priceS!,
                                          widget.product!.priceL!,
                                          _isLargeSize
                                        )} ${App.currency}",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: PlatformButton(
                                        text: "Add to cart",
                                        onPressed: (){

                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                  ],
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
      ),
    );
  }
}

class ProductSize extends StatelessWidget {
  final String? title;
  final bool? isSelected;
  final Function? onTap;

  const ProductSize({
    Key? key,
    this.title,
    this.isSelected,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: isSelected! ? 1.5 : 0,
              color: HexColor.fromHex(App.appColor)
            ),
            color: isSelected! ?
            Colors.transparent :
            Colors.grey.withOpacity(0.75)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
          child: Center(
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isSelected! ?
                  HexColor.fromHex(App.appColor) :
                  Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}

