import 'package:cable/fast_op/client_change_notifier.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientProvider extends StatelessWidget {
  final Map<String, String> defaultHeaders;
  final Map<OperationType, FetchPolicy> defaultFetchPolicies;
  final String endpoint;
  final Widget Function(BuildContext context, Widget? child)? builder;
  final Widget? child;

  ClientProvider({
    Key? key,
    required this.endpoint,
    this.child,
    this.builder,
    this.defaultHeaders = const {},
    this.defaultFetchPolicies = const {},
  }) : super(key: key);

  Widget build(BuildContext context) {
    return ListenableProvider<ClientChangeNotifier>(
      create: (context) => ClientChangeNotifier(
        endpoint: endpoint,
        defaultFetchPolicies: defaultFetchPolicies,
        defaultHeaders: defaultHeaders,
      ),
      child: child,
      builder: builder,
    );
  }
}
