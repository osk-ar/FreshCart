import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/inventory/events/inventory_event.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:supermarket/presentation/blocs/inventory/states/inventory_state.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/inventory_product.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/inventory_product_shimmer.dart';
import 'package:supermarket/presentation/widgets/search_sliver_appbar.dart';
import 'package:supermarket/presentation/widgets/sliver_appbar_with_search_button.dart';

class InventoryPhone extends StatefulWidget {
  const InventoryPhone({super.key});

  @override
  State<InventoryPhone> createState() => _InventoryPhoneState();
}

class _InventoryPhoneState extends State<InventoryPhone> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(InventoryFetchItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BlocBuilder<InventoryBloc, InventoryState>(
          buildWhen: (previous, current) {
            return current is InventorySearching || current is InventoryLoaded;
          },
          builder: (context, state) {
            log(state.runtimeType.toString());
            switch (state) {
              case InventorySearching():
                return SearchSliverAppbar(
                  onSearchChanged: (query) {
                    context.read<InventoryBloc>().add(
                      InventoryChangeSearchEvent(query),
                    );
                  },
                  onClear: () {
                    final String lastQuery =
                        context.read<InventoryBloc>().searchQuery;

                    if (lastQuery.isEmpty) {
                      context.pop();
                      context.read<InventoryBloc>().add(
                        InventoryEndSearchEvent(),
                      );
                      return;
                    }

                    context.read<InventoryBloc>().add(
                      InventoryChangeSearchEvent(""),
                    );
                  },
                );
              default:
                return SliverAppbarWithSearchButton(
                  title: AppStrings.inventory,
                  onSearchPressed: () {
                    context.read<InventoryBloc>().add(
                      InventoryStartSearchEvent(),
                    );
                    ModalRoute.of(context)!.addLocalHistoryEntry(
                      LocalHistoryEntry(
                        onRemove: () {
                          context.read<InventoryBloc>().add(
                            InventoryEndSearchEvent(),
                          );
                        },
                      ),
                    );
                  },
                );
            }
          },
        ),

        SliverToBoxAdapter(child: SizedBox(height: 8.h)),

        BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            switch (state) {
              case InventorySearching():
                return SliverList.builder(
                  itemCount: state.searchedProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.searchedProducts.length) {
                      return context
                                  .read<InventoryBloc>()
                                  .isSearchLastItemReached ||
                              state.searchedProducts.isEmpty
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.searchedProducts.isEmpty
                                    ? "No products found for this query"
                                    : "No More Results",
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                    }
                    return InventoryProduct(
                      product: state.searchedProducts[index],
                      onEdit:
                          () => context.pushNamed(
                            AppRoutes.addItem,
                            arguments: state.searchedProducts[index],
                          ),
                      onDelete: () {},
                      onRestock: () {},
                    );
                  },
                );
              case InventoryLoaded():
                return SliverList.builder(
                  itemCount: state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.products.length) {
                      return context.read<InventoryBloc>().isFeedLastItemReached
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.products.isEmpty
                                    ? "No Products Found, try adding an item!"
                                    : "No More Results",
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                    }
                    return InventoryProduct(
                      product: state.products[index],
                      onEdit:
                          () => context.pushNamed(
                            AppRoutes.addItem,
                            arguments: state.products[index],
                          ),
                      onDelete: () {},
                      onRestock: () {},
                    );
                  },
                );

              default:
                return SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const InventoryProductShimmer();
                  },
                );
            }
          },
        ),
      ],
    );
  }
}
