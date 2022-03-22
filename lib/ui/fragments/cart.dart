import 'package:coffee/data/utils/localization.dart';
import 'package:flutter/material.dart';

class CartFragment extends StatelessWidget {
  const CartFragment({Key? key}) : super(key: key);

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
            AppLocalizations.of(context, 'cart'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                "Cart is in development"
              ),
            ),
          )
        ],
      ),
    );
  }
}
