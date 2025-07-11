abstract class CashierEvent {}

//*search
class StartSearchEvent extends CashierEvent {}

class SearchChangedEvent extends CashierEvent {
  final String query;

  SearchChangedEvent(this.query);
}

class EndSearchEvent extends CashierEvent {}

//*cart
class AddToCartEvent extends CashierEvent {}

class RemoveFromCartEvent extends CashierEvent {}

//*checkout
class StartCheckoutEvent extends CashierEvent {}

class FinishCheckoutEvent extends CashierEvent {}

class CancelCheckoutEvent extends CashierEvent {}
