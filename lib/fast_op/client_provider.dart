import 'package:cable/fast_op/client_change_notifier.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientProvider extends ChangeNotifierProvider {
  ClientProvider({
    Key? key,
    Widget Function(BuildContext, Widget?)? builder,
    Widget? child,
    required String endpoint,
    Map<String, String> defaultHeaders = const {},
    Map<OperationType, FetchPolicy> defaultFetchPolicies = const {},
  }) : super(
          create: (context) => ClientChangeNotifier(
            endpoint: endpoint,
            defaultHeaders: defaultHeaders,
            defaultFetchPolicies: defaultFetchPolicies,
          ),
          builder: builder,
          child: child,
          key: key,
          lazy: false,
        );
}
