import 'package:sandra/app/core/importer.dart';

import '/app/core/values/app_values.dart';
import '/app/core/widget/asset_image_view.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    super.key,
    this.fileName,
    this.icon,
    this.value,
    this.height,
    this.width,
    this.size,
    this.color,
  });

  final String? fileName;
  final IconData? icon;
  final String? value;
  final double? height;
  final double? width;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (fileName != null) {
      return _getImage(fileName!);
    } else if (icon != null) {
      return _getIcon(icon!);
    } else {
      return _getIcon(Icons.image_not_supported_outlined);
    }
  }

  Widget _getIcon(IconData iconData) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: size, color: color),
          const SizedBox(width: AppValues.margin_2),
          if (value != null) Text(value!, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _getImage(String fileName) {
    return Expanded(
      child: Row(
        children: [
          AssetImageView(
            fileName: fileName,
            height: height,
            width: width,
            color: color,
          ),
          const SizedBox(width: AppValues.margin_2),
          if (value != null) Text(value!, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
