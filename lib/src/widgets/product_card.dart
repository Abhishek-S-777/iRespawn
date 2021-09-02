import 'package:irespawn/src/themes/dark_color.dart';
import 'package:flutter/material.dart';

import 'package:irespawn/src/model/product.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/widgets/title_text.dart';
import 'package:irespawn/src/widgets/extentions.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final ValueChanged<Product> onSelected;
  ProductCard({Key key, this.product, this.onSelected}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          // BoxShadow(color: Color(0xf095f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: !widget.product.isSelected ? 20 : 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  widget.product.isliked ? Icons.favorite : Icons.favorite_border,
                  color:
                      widget.product.isliked ? LightColor.red : LightColor.iconColor,
                ),
                onPressed: () {},
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: widget.product.isSelected ? 15 : 0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: LightColor.orange.withAlpha(40),
                      ),
                      Image.asset(widget.product.image)
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: widget.product.name,
                  fontSize: widget.product.isSelected ? 16 : 14,
                ),
                TitleText(
                  text: widget.product.category,
                  fontSize: widget.product.isSelected ? 14 : 12,
                  color: LightColor.orange,
                ),
                TitleText(
                  text: widget.product.price.toString(),
                  fontSize: widget.product.isSelected ? 18 : 16,
                ),
              ],
            ),
          ],
        ),
      ).ripple(() {
        Navigator.of(context).pushNamed('/detail');
        widget.onSelected(widget.product);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
