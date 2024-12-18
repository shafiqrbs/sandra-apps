import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/add_button.dart';
import 'package:sandra/app/core/widget/app_bar_search_view.dart';
import 'package:sandra/app/core/widget/search_button.dart';

import '/app/pages/inventory/category_list_page/controllers/category_list_page_controller.dart';

//ignore: must_be_immutable
class CategoryListPageView extends BaseView<CategoryListPageController> {
  CategoryListPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.categoryList,
            controller: controller.categoryManager.searchTextController.value,
            onSearch: controller.categoryManager.searchItemsByNameOnAllItem,
            onMicTap: controller.isSearchSelected.toggle,
            onFilterTap: () {},
            onClearTap: controller.onClearSearchText,
            showSearchView: controller.isSearchSelected.value,
            isShowFilter: false,
          );
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        Obx(
          () {
            if (controller.isSearchSelected.value) {
              return Container();
            }
            return AppBarButtonGroup(
              children: [
                AddButton(
                  onTap: controller.onAddCategory,
                ),
                SearchButton(
                  onTap: controller.isSearchSelected.toggle,
                ),
                QuickNavigationButton(),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          itemCount: controller.categoryManager.allItems.value?.length ?? 0,
          controller: controller.categoryManager.scrollController,
          padding: const EdgeInsets.only(bottom: 60),
          itemBuilder: (context, index) {
            final element = controller.categoryManager.allItems.value![index];
            return InkWell(
              onTap: () {
                controller.onCategoryTap(element);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 2,
                        left: 16,
                        right: 16,
                        top: 2,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: index.isEven
                              ? colors.secondaryColor50
                              : colors.primaryColor50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            32,
                            16,
                            12,
                            16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        element.name ?? '',
                                        style: TextStyle(
                                          fontSize: mediumTFSize,
                                          color: colors.solidBlackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  16.width,
                                  InkWell(
                                    onTap: () =>
                                        controller.editCategory(element),
                                    child: const Icon(
                                      TablerIcons.edit,
                                      size: 18,
                                    ),
                                  ),
                                  16.width,
                                  const Icon(
                                    TablerIcons.chevron_right,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        height: 36,
                        width: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primaryColor100.withOpacity(.5),
                        ),
                        //padding: const EdgeInsets.all(8),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: smallTFSize,
                            color: colors.solidBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
