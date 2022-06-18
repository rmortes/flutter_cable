import 'package:ferry/ferry.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FastOp<TData, TVars> extends StatelessWidget {
  final Function(
    BuildContext context,
    Client? client,
    OperationResponse<TData, TVars>? response,
    Object? error,
  ) builder;
  final OperationRequest<TData, TVars> request;
  final Widget? onLoading;
  final Widget Function(
          BuildContext context, OperationResponse? r, Object? error)?
      onErrorBuilder;

  FastOp({
    Key? key,
    required this.builder,
    required this.request,
    this.onLoading = _defaultOnLoading,
    this.onErrorBuilder = _defaultOnErrorBuilder,
  }) : super(key: key);

  final _client = GetIt.instance.get<Client>();

  static const _defaultOnLoading = Center(
    child: CircularProgressIndicator(),
  );

  static Widget _defaultOnErrorBuilder(
          _, OperationResponse? r, Object? error) =>
      Center(
        child: Column(
          children: [
            for (final err in r?.graphqlErrors ?? []) Text(err.message),
            Text(error?.toString() ?? "No error available"),
          ],
        ),
      );

  bool _renderLoading(OperationResponse? r) =>
      onLoading != null && (r?.loading ?? false);

  bool _renderError(OperationResponse? r) =>
      onErrorBuilder != null && (r?.hasErrors ?? false);

  @override
  Widget build(BuildContext context) {
    return Operation(
      client: _client,
      operationRequest: request,
      builder: (context, OperationResponse<TData, TVars>? response, error) {
        // If onloading is set, let us handle it.
        if (_renderLoading(response)) {
          return onLoading!;
        }

        // If onerror is set, and there is an error let us handle it.
        if (_renderError(response)) {
          return onErrorBuilder!.call(context, response, error);
        }

        return builder(context, _client, response, error);
      },
    );
  }
}
