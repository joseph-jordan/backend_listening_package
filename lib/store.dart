import 'queue_listener.dart';
import 'converter.dart';

abstract class Store<T> {
  QueueListener<T> _listener;

  Store(Converter<T> converter) {
    this._listener = new QueueListener<T>(converter, onAllUpdates: updateCache);
  }

  void updateCache(List<T> newData);

  bool isLoaded();

  QueueListener<T> getListener() {
    return _listener;
  }

}