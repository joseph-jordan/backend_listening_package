import 'persisted_object.dart';
import 'dart:async';


typedef StreamSubscription SubscriptionGenerator(OnStreamUpdate onStreamUpdates);
typedef void OnStreamUpdate(List<PersistedObject> snapshot);