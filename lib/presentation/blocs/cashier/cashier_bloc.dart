import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/cashier/events/cashier_event.dart';
import 'package:supermarket/presentation/blocs/cashier/states/cashier_state.dart';

class CashierBloc extends Bloc<CashierEvent, CashierState> {
  CashierBloc() : super(CashierInitial()) {
    on<StartSearchEvent>((event, emit) {
      log("start search");
      emit(CashierSearching(products));
    });

    on<SearchChangedEvent>((event, emit) {
      log("change search:---- ${event.query}");
    });

    on<EndSearchEvent>((event, emit) {
      log("end search");
      emit(CashierLoaded(products));
    });
  }

  List<ProductEntity> products = [];
  List<ProductEntity> searchedProducts = [];
}
