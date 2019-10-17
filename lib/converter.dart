import 'persisted_object.dart';

abstract class Converter<T> {


  PersistedObject toPersistence(T object);

  T fromPersistence(PersistedObject snapshot);

}