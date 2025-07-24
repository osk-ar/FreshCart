import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/blocs/inventory/states/inventory_state.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/inventory_product_shimmer.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/inventory_product_widget.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/remove_item_dialog.dart';
import 'package:supermarket/presentation/widgets/infinite_scroll_helper_widgets.dart';
import 'package:supermarket/presentation/widgets/search_sliver_appbar.dart';
import 'package:supermarket/presentation/widgets/sliver_appbar_with_search_button.dart';

class InventoryPhone extends StatefulWidget {
  const InventoryPhone({super.key});

  @override
  State<InventoryPhone> createState() => _InventoryPhoneState();
}

class _InventoryPhoneState extends State<InventoryPhone> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<InventoryCubit>().refresh();
      },
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: CustomScrollView(
        slivers: [
          BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              log(state.runtimeType.toString());
              switch (state) {
                case InventorySearch():
                  return SearchSliverAppbar(
                    onSearchChanged: (query) {
                      context.read<InventoryCubit>().updateSearchQuery(query);
                    },
                  );
                default:
                  return SliverAppbarWithSearchButton(
                    title: AppStrings.inventory,
                    onSearchPressed: () {
                      context.read<InventoryCubit>().switchState();
                      ModalRoute.of(context)!.addLocalHistoryEntry(
                        LocalHistoryEntry(
                          onRemove: () {
                            context.read<InventoryCubit>().switchState();
                          },
                        ),
                      );
                    },
                  );
              }
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 8.h)),

          BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              final bool isSearching = state is InventorySearch;
              return PagedSliverList<int, ProductEntity>(
                state: state.pagingState,
                fetchNextPage:
                    isSearching
                        ? context.read<InventoryCubit>().fetchSearch
                        : context.read<InventoryCubit>().fetchFeed,
                builderDelegate: PagedChildBuilderDelegate<ProductEntity>(
                  invisibleItemsThreshold: 8,
                  itemBuilder:
                      (context, item, index) => InventoryProductWidget(
                        product: item,
                        onEdit:
                            () => context.pushNamed(
                              AppRoutes.addItem,
                              arguments: item,
                            ),
                        onDelete:
                            () => context.dialog(
                              body: RemoveItemDialogBody(
                                onConfirm: () {
                                  context.read<InventoryCubit>().removeProduct(
                                    item,
                                  );

                                  context.pop();
                                },
                                onCancel: () => context.pop(),
                              ),
                            ),
                        onRestock:
                            () => context.pushNamed(
                              AppRoutes.addBatch,
                              arguments: item,
                            ),
                      ),

                  firstPageProgressIndicatorBuilder: (context) {
                    return const FirstPageProgressIndicator(
                      shimmer: InventoryProductShimmer(),
                    );
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return SizedBox(
                      height: 64.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  noItemsFoundIndicatorBuilder:
                      (context) => NoItemsFoundIndicator(isSearch: isSearching),
                  noMoreItemsIndicatorBuilder:
                      (context) => const NoMoreItemsIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
