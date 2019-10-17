import 'store.dart';
import 'subscription_generator.dart';

class ListenerClient<StoreType> {
  SubscriptionGenerator _subscribeTo;
  final StoreType _store;
  final DateTime _initializationTimeStamp;

  ListenerClient(this._store, this._subscribeTo) : _initializationTimeStamp = DateTime.now();

  StoreType getStore() {
    return _store;
  }

  String getClientID() {
    return this.toString() + ":" + _initializationTimeStamp.toIso8601String();
  }

  @override
  String toString() {
    return "StoreSubscriber for ${_store.runtimeType.toString()}";
  }

  void updateSubscriptionGenerator({SubscriptionGenerator newSubscription}) {
    if (newSubscription != null) {
      _subscribeTo = newSubscription;
    }
    if (_subscribeTo != null) {
      Store store = _store as Store;
      store.getListener().updateSubscriptionGenerator(_subscribeTo, this);
    }
  }
}
