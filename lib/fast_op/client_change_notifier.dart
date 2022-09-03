import 'package:cable/fast_op/_utils.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/foundation.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_sse_link/gql_sse_link.dart';

class ClientChangeNotifier extends ChangeNotifier {
  final String endpoint;
  final Map<OperationType, FetchPolicy> defaultFetchPolicies;
  Client get client => _client;

  ClientChangeNotifier({
    required this.endpoint,
    Map<String, String> defaultHeaders = const {},
    this.defaultFetchPolicies = const {},
  })  : _headers = defaultHeaders,
        assert(
            endpoint.startsWith("http://") || endpoint.startsWith("https://"),
            "The endpoint must start with http:// or https://");

  Map<String, String> _headers;
  late Client _client = _newClient();

  void setHeaders(Map<String, String> headers) {
    _headers = headers;
    _client = _newClient();
    notifyListeners();
  }

  void setAuthorization(String authorization) {
    _headers["Authorization"] = authorization;
    _client = _newClient();
    notifyListeners();
  }

  void setToken(String token) {
    _headers["Authorization"] = "Bearer $token";
    _client = _newClient();
    notifyListeners();
  }

  Client _newClient() {
    final httpLink = HttpLink(endpoint, defaultHeaders: _headers);
    final sseLink = SSELink(endpoint, defaultHeaders: _headers);
    final link = Link.split(
      (req) => req.isSubscription,
      sseLink,
      httpLink,
    );
    return Client(
      defaultFetchPolicies: defaultFetchPolicies,
      link: link,
    );
  }
}
