import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget commonCacheImageWidget(
  String? url,
  double height, {
  double? width,
  BoxFit? fit,
}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder:
            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorWidget: (_, __, ___) {
          return SizedBox(
            height: height,
            width: width,
          );
        },
      );
    } else {
      return Image.network(
        url!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }
  } else {
    return placeHolderWidget(
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      alignment: Alignment.center,
      radius: 2,
    );
  }
}

Widget? Function(BuildContext, String) placeholderWidgetFn() {
  return (_, s) => placeholderWidget();
}

Widget placeholderWidget() {
  return Image.asset(
    'assets/images/place_holder.png',
    fit: BoxFit.cover,
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
      height: 100,
      width: 100,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      radius: 2,
    );
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
      color: Colors.transparent,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            //  colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
          height: 100,
          width: 100,
          fit: BoxFit.fill,
          alignment: Alignment.center,
          radius: 2,
        );
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
          height: 100,
          width: 200,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          radius: 2,
        );
      },
    );
  } else {
    return Image.asset(
      url,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    ).cornerRadiusWithClipRRect(defaultRadius);
  }
}

Widget placeHolderWidget({
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  double? radius,
}) {
  return Image.asset(
    'assets/images/place_holder.png',
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
  ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

BoxDecoration boxDecoration({
  double radius = 2,
  Color color = Colors.transparent,
  Color? bgColor,
  var showShadow = false,
}) {
  return BoxDecoration(
    color: bgColor ?? Colors.grey,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [
            const BoxShadow(color: Colors.transparent),
          ],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}
