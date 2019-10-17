import 'package:flutter/material.dart';
import 'store.dart';
import 'listener_client.dart';

abstract class ListenerWidgetState<T> extends State<StatefulWidget> {

  void _onUpdateCallBack() {
    setState(() {});
  }

  List<ListenerClient> getUsedListenerClients();

  @override
  void initState() {
    super.initState();
    for (ListenerClient client in getUsedListenerClients()) {
      client.updateSubscriptionGenerator();
      Store store = client.getStore();
      store.getListener().beginListening(_onUpdateCallBack, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (ListenerClient client in getUsedListenerClients()) {
      Store store = client.getStore();
      store.getListener().terminateSubscription(client);
    }
  }

  bool allDataLoaded() {
    return getUsedListenerClients().every((ListenerClient client) => client.getStore().isLoaded());
  }
}