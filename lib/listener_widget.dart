import 'package:flutter/material.dart';
import 'store.dart';
import 'listener_client.dart';

abstract class ListenerWidgetState<T> extends State<StatefulWidget> {

  void _onUpdateCallBack() {
    setState(() {});
  }

  List<ListenerClient> getUsedListenerClients();

  List<ListenerClient> copyOfUsedListenerClients;

  @override
  void initState() {
    super.initState();
    copyOfUsedListenerClients = getUsedListenerClients();
    for (ListenerClient client in copyOfUsedListenerClients) {
      client.updateSubscriptionGenerator();
      Store store = client.getStore();
      store.getListener().beginListening(_onUpdateCallBack, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (ListenerClient client in copyOfUsedListenerClients) {
      Store store = client.getStore();
      store.getListener().terminateSubscription(client);
    }
  }

  bool allDataLoaded() {
    return copyOfUsedListenerClients.every((ListenerClient client) => client.getStore().isLoaded());
  }
}