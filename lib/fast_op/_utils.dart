import "package:gql/ast.dart";
import "package:gql_exec/gql_exec.dart" as gql;

extension WithType on gql.Request {
  OperationType get type {
    final definitions = operation.document.definitions
        .whereType<OperationDefinitionNode>()
        .toList();
    if (operation.operationName != null) {
      definitions.removeWhere(
        (node) => node.name!.value != operation.operationName,
      );
    }
    // TODO differentiate error types, add exception
    assert(definitions.length == 1);
    return definitions.first.type;
  }

  bool get isSubscription => type == OperationType.subscription;
  bool get isQuery => type == OperationType.query;
  bool get isMutation => type == OperationType.mutation;
}
