import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '/app/core/base/base_widget.dart';

class DialogPattern extends BaseWidget {
  final String title;
  final String subTitle;
  final Widget child;
  DialogPattern({
    required this.title,
    required this.subTitle,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(
        left: 2,
        right: 2,
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.grey.withOpacity(.9),
      elevation: 0,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                 containerBorderRadius,
                ),
                color: colors.moduleBodyColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.moduleHeaderColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              containerBorderRadius,
                            ),
                            topLeft: Radius.circular(
                              containerBorderRadius,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            bottom: 8,
                            top: 60,
                            right: 16,
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: headerTFSize,
                                    color: colors.primaryTextColor,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                child: Text(
                                  subTitle,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: subHeaderTFSize,
                                    color: colors.secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 15,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            TablerIcons.x,
                            color: colors.dangerLiteColor,
                            size: closeIconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child,
                ],
              ),
            ),
            Positioned(
              top: 10,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: colors.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset('assets/images/app_logo.png'),
                    ),
                  ),
                  //child: CircleAvatar(backgroundImage: AssetImage('assets/images/logo.png'), ),
                  /*child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(TablerIcons.file_plus, color: colors.iconColor,
                        size: 60,
                      ),
                      Text("add".tr, style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: headerTFSize
                      ),)
                    ],
                  ),*/
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
