import 'package:cached_network_image/cached_network_image.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:nb_utils/nb_utils.dart';

Widget commonCacheImageWidget(
  String? url,
  double height, {
  double? width,
  BoxFit? fit,
  bool isOval = false, // Add isOval parameter
}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return isOval
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: url!,
                height: height,
                width: width ?? height,
                fit: fit ?? BoxFit.cover,
                errorWidget: (_, __, ___) {
                  return placeHolderWidget(
                      height: height, width: width, isOval: isOval);
                },
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
                errorWidget: (_, __, ___) {
                  return placeHolderWidget(
                      height: height, width: width, isOval: isOval);
                },
              ),
            );
    } else {
      return isOval
          ? ClipOval(
              child: Image.network(
                url!,
                height: height,
                width: width ?? height,
                fit: fit ?? BoxFit.cover,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
              ),
            );
    }
  } else {
    return placeHolderWidget(
      height: height,
      width: width,
      isOval: isOval,
    );
  }
}

Widget commonCachedNetworkImage(
  String? url, {
  double height = 100.0,
  double? width,
  BoxFit? fit,
  double? radius,
  bool usePlaceholderIfUrlEmpty = true,
  bool isOval = false,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, isOval: isOval);
  } else if (url.validate().startsWith('http') ||
      url.validate().startsWith('www')) {
    return isOval
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              height: height,
              width: width ?? height,
              fit: fit ?? BoxFit.cover,
              errorWidget: (_, __, ___) {
                return placeHolderWidget(
                    height: height, width: width, isOval: isOval);
              },
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 10),
            child: CachedNetworkImage(
              imageUrl: url,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              errorWidget: (_, __, ___) {
                return placeHolderWidget(
                    height: height, width: width, isOval: isOval);
              },
            ),
          );
  } else {
    return isOval
        ? ClipOval(
            child: Image.asset(
              url,
              height: height,
              width: width ?? height,
              fit: fit ?? BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              url,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            ),
          );
  }
}

Widget placeHolderWidget({
  double? height,
  double? width,
  BoxFit? fit,
  bool isOval = false,
}) {
  return isOval
      ? ClipOval(
          child: Image.asset(
            'assets/images/place_holder.png',
            height: height,
            width: width ?? height,
            fit: fit ?? BoxFit.cover,
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.asset(
            'assets/images/place_holder.png',
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          ),
        );
}
