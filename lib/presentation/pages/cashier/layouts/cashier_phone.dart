import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/presentation/blocs/cashier/events/cashier_event.dart';
import 'package:supermarket/presentation/blocs/cashier/cashier_bloc.dart';
import 'package:supermarket/presentation/blocs/cashier/states/cashier_state.dart';
import 'package:supermarket/presentation/widgets/sliver_appbar_with_search_button.dart';
import 'package:supermarket/presentation/widgets/search_sliver_appbar.dart';

class CashierPhone extends StatelessWidget {
  const CashierPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BlocBuilder<CashierBloc, CashierState>(
              builder: (context, state) {
                log(state.runtimeType.toString());
                switch (state) {
                  case CashierSearching():
                    return SearchSliverAppbar(
                      onSearchChanged: (query) {
                        context.read<CashierBloc>().add(
                          SearchChangedEvent(query),
                        );
                      },
                    );

                  default:
                    return SliverAppbarWithSearchButton(
                      title: AppStrings.appName,
                      onSearchPressed: () {
                        context.read<CashierBloc>().add(StartSearchEvent());
                        ModalRoute.of(context)!.addLocalHistoryEntry(
                          LocalHistoryEntry(
                            onRemove: () {
                              context.read<CashierBloc>().add(EndSearchEvent());
                            },
                          ),
                        );
                      },
                    );
                }
              },
            ),

            SliverToBoxAdapter(child: SizedBox(height: 8.h)),

            SliverList.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return Text("data");
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
1- initial : not searching empty screen
2- loading feed: not searching show shimmer cards
3- loaded feed: not searching show feed list
4- start search event: searching show search list
5- end search event: not searching show feed list

add to cart event
remove from cart event

start checkout event
finish checkout event
cancel checkout event


 */


/*
list
product_id
quantity
one-price
 */