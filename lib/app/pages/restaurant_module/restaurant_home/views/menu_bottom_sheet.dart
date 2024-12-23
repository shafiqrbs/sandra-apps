import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/category.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';

class MenuBottomSheet {
  final List<Category> menuItems;
  final BuildContext context;

  MenuBottomSheet({
    required this.context,
    required this.menuItems,
  });

  // Function to display the menu with left-side animation
  void showMenuFromLeft() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            // Add Material here to solve the issue
            color: Colors.transparent,
            child: _buildMenuList(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from the left
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Start off-screen (left)
          end: Offset.zero, // Slide into view
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget _buildMenuList() {
    final colors = ColorSchema();
    final controller = Get.find<RestaurantHomeController>();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.height * .4,
        minHeight: Get.height * .2,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: Get.width * .6, // Set a width for the side menu
            //height: 300,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(
                  AppValues.radius_8,
                ),
                bottomRight: Radius.circular(
                  AppValues.radius_8,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: controller.allCategory,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppValues.radius_4,
                      ),
                      color: colors.secondaryColor50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appLocalization.allCategory,
                          style: AppTextStyle.h2TextStyle500.copyWith(
                            color: colors.textColor500,
                          ),
                        ),
                        Icon(
                          TablerIcons.reload,
                          color: colors.textColor500,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return GestureDetector(
                        onTap: () => controller.filterByCategory(
                          item,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppValues.radius_4,
                            ),
                            color: colors.secondaryColor50,
                          ),
                          child: Text(
                            item.name ?? '',
                            style: AppTextStyle.h2TextStyle500.copyWith(
                              color: colors.textColor500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Transform.translate(
              offset: const Offset(
                65,
                0,
              ), // Adjust this value to move the widget to the left
              child: Transform.rotate(
                angle: -3.14159 / 2, // Rotate 90 degrees (π/2 radians)
                child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          AppValues.radius_8,
                        ),
                        bottomRight: Radius.circular(
                          AppValues.radius_8,
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colors.primaryColor500,
                          colors.secondaryColor500
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensure the size is adjusted to content
                      children: [
                        Icon(
                          TablerIcons.tools_kitchen_2,
                          size: 20,
                          color: colors.whiteColor,
                        ),
                        6.width,
                        Text(
                          appLocalization.menu,
                          style: AppTextStyle.h2TextStyle700.copyWith(
                            color: colors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
