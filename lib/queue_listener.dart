import 'dart:async';
import 'converter.dart';
import 'subscription_generator.dart';
import 'package:flutter/foundation.dart';
import 'listener_client.dart';
import 'persisted_object.dart';

typedef void OnUpdateCallBack<T>(List<T> updatedData);

class QueueListener<T> {
  final Converter<T> _converter;
  final OnUpdateCallBack<T> onAllUpdates;


  QueueListener(this._converter, {this.onAllUpdates});

  Map<String, SubscriptionGenerator> _subscriptionGenerators = new Map<String, SubscriptionGenerator>();
  Map<String, StreamSubscription> _currentSubscriptions = new Map<String, StreamSubscription>();
  Map<String, VoidCallback> _onUpdateCallBacks = new Map<String, VoidCallback>();

  bool alreadySubscribed(ListenerClient client) {
    return _currentSubscriptions.containsKey(client.getClientID());
  }

  bool hasSubscriptionGeneratorReady(ListenerClient client) {
    return _subscriptionGenerators.containsKey(client.getClientID());
  }

  void _executeOnAllUpdatesWrapper(List<T> updatedData) {
    if (onAllUpdates != null) {
      onAllUpdates(updatedData);
    }
  }

  void beginListening(VoidCallback onUpdate, ListenerClient client) {
    if (!hasSubscriptionGeneratorReady(client)) {
      throw Exception("No subscription generator ready!");
    } else if (alreadySubscribed(client)) {
      throw Exception("There is already a client subscribed!");
    }
    _onUpdateCallBacks[client.getClientID()] = onUpdate;
    _generateStream(client);
  }

  void updateSubscriptionGenerator(SubscriptionGenerator newSubscriptionGenerator, ListenerClient client) {
    _subscriptionGenerators[client.getClientID()] = newSubscriptionGenerator;
    if (alreadySubscribed(client)) {
      _currentSubscriptions[client.getClientID()].cancel();
      _generateStream(client);
    }
  }

  void _generateStream(ListenerClient client) {
    _currentSubscriptions[client.getClientID()] = _subscriptionGenerators[client.getClientID()]((List<PersistedObject> persistedObjects) {
      List<T> newData = persistedObjects.map((PersistedObject snapshot) => _converter.fromPersistence(snapshot)).toList();
      _executeOnAllUpdatesWrapper(newData);
      _onUpdateCallBacks[client.getClientID()]();
    });
  }

  void terminateSubscription(ListenerClient client) {
    if (alreadySubscribed(client)) {
      _currentSubscriptions[client.getClientID()].cancel();
      _currentSubscriptions.remove(client.getClientID());
    }
  }
}