import 'package:ferry/ferry.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cable/fast_op/client_change_notifier.dart';
export 'package:cable/fast_op/fast_op.dart' show FastOp;
export 'package:cable/fast_op/client_change_notifier.dart'
    show ClientChangeNotifier;
export 'package:cable/fast_op/client_provider.dart' show ClientProvider;

typedef Res<D, V> = OperationResponse<D, V>;
typedef Req<D, V> = OperationRequest<D, V>;
typedef Widget ErrorBuilder<D, V>(
    BuildContext context, Res<D, V> r, Object? error);

class FastOp<D, V> extends StatelessWidget {
  final Function(
    BuildContext context,
    ClientChangeNotifier client,
    Res<D, V> response,
    Object? error,
  ) builder;
  final Req<D, V> request;
  final Widget onLoading;
  final ErrorBuilder<D, V>? _onErrorBuilder;

  ErrorBuilder<D, V> get onErrorBuilder =>
      _onErrorBuilder ?? _defaultOnErrorBuilder;

  FastOp({
    Key? key,
    required this.builder,
    required this.request,
    this.onLoading = _defaultOnLoading,
    ErrorBuilder<D, V>? onErrorBuilder,
  })  : this._onErrorBuilder = onErrorBuilder,
        super(key: key);

  static const _defaultOnLoading = Center(
    child: CircularProgressIndicator(),
  );

  Widget _defaultOnErrorBuilder(_, Res<D, V> r, Object? error) => Center(
        child: Column(
          children: [
            for (final err in r.graphqlErrors ?? []) Text(err.message),
            Text(error?.toString() ?? "No error available"),
          ],
        ),
      );

  /// This method returns true if the operation is still loading.
  /// The response being null means that the operation is still loading.
  bool _renderLoading(Res? r) => r == null || r.loading;

  /// This method returns true if the operation has an error.
  bool _renderError(Res? r) => r?.hasErrors ?? false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientChangeNotifier>(
      builder: (context, clientModel, child) => Operation(
        client: clientModel.client,
        operationRequest: request,
        builder: (context, Res<D, V>? response, error) {
          if (_renderLoading(response)) {
            return onLoading;
          } else {
            // Cast needed, because _renderLoading (which will trigger if response is null) doesn't cast
            // response as not null
            response as OperationResponse<D, V>;
          }

          if (_renderError(response)) {
            return onErrorBuilder.call(context, response, error);
          }

          return builder(context, clientModel, response, error);
        },
      ),
    );
  }
}
