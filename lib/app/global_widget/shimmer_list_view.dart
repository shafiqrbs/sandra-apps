import 'package:sandra/app/core/importer.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final String msg;
  const ShimmerListView({
    required this.itemCount,
    required this.msg,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 200,
            height: 100,
            child: Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
