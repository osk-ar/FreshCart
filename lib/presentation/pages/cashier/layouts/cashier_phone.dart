import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/cashier/cashier_pagination_cubit.dart';
import 'package:supermarket/presentation/blocs/cashier/states/cashier_pagination_state.dart';
import 'package:supermarket/presentation/pages/cashier/widgets/cashier_product_shimmer.dart';
import 'package:supermarket/presentation/pages/cashier/widgets/cashier_product_widget.dart';
import 'package:supermarket/presentation/widgets/infinite_scroll_helper_widgets.dart';
import 'package:supermarket/presentation/widgets/sliver_appbar_with_search_button.dart';
import 'package:supermarket/presentation/widgets/search_sliver_appbar.dart';

class CashierPhone extends StatelessWidget {
  const CashierPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<CashierPaginationCubit>().refresh();
      },
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: CustomScrollView(
        slivers: [
          BlocBuilder<CashierPaginationCubit, CashierPaginationState>(
            builder: (context, state) {
              log(state.runtimeType.toString());
              switch (state) {
                case CashierSearch():
                  return SearchSliverAppbar(
                    onSearchChanged:
                        (query) => context
                            .read<CashierPaginationCubit>()
                            .updateSearchQuery(query),
                  );

                default:
                  return SliverAppbarWithSearchButton(
                    title: AppStrings.appName,
                    onSearchPressed: () {
                      context.read<CashierPaginationCubit>().switchState();
                      ModalRoute.of(context)!.addLocalHistoryEntry(
                        LocalHistoryEntry(
                          onRemove: () {
                            context
                                .read<CashierPaginationCubit>()
                                .switchState();
                          },
                        ),
                      );
                    },
                  );
              }
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 8.h)),

          BlocBuilder<CashierPaginationCubit, CashierPaginationState>(
            builder: (context, state) {
              final bool isSearching = state is CashierSearch;
              return PagedSliverList<int, ProductEntity>(
                state: state.pagingState,
                fetchNextPage:
                    isSearching
                        ? context.read<CashierPaginationCubit>().fetchSearch
                        : context.read<CashierPaginationCubit>().fetchFeed,
                builderDelegate: PagedChildBuilderDelegate<ProductEntity>(
                  invisibleItemsThreshold: 8,
                  itemBuilder:
                      (context, item, index) => CashierProductWidget(
                        product: item,
                        onAddToCart:
                            () => context.pushNamed(
                              AppRoutes.addItem,
                              arguments: item,
                            ),
                      ),

                  firstPageProgressIndicatorBuilder: (context) {
                    return const FirstPageProgressIndicator(
                      shimmer: CashierProductShimmer(),
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
