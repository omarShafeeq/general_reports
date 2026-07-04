import '../models/function_call.dart';

typedef FunctionHandler = Future<dynamic> Function(Map<String, dynamic> args);

/// Registry of callable functions the AI can invoke.
///
/// Each entry maps a function name to an async handler.  The registry is
/// populated at startup and passed to the AI provider so the model knows
/// which tools it can call.
class FunctionRegistry {
  final Map<String, _RegisteredFunction> _functions = {};

  void register({
    required String name,
    required String description,
    required FunctionHandler handler,
    Map<String, FunctionParam> parameters = const {},
  }) {
    _functions[name] = _RegisteredFunction(
      definition: FunctionDefinition(
        name: name,
        description: description,
        parameters: parameters,
      ),
      handler: handler,
    );
  }

  List<FunctionDefinition> get definitions =>
      _functions.values.map((f) => f.definition).toList();

  Future<FunctionCall> execute(FunctionCall call) async {
    final fn = _functions[call.name];
    if (fn == null) {
      return call.withResult({'error': 'Unknown function: ${call.name}'});
    }
    try {
      final result = await fn.handler(call.arguments);
      return call.withResult(result);
    } catch (e) {
      return call.withResult({'error': e.toString()});
    }
  }

  bool has(String name) => _functions.containsKey(name);
}

class _RegisteredFunction {
  final FunctionDefinition definition;
  final FunctionHandler handler;
  const _RegisteredFunction({required this.definition, required this.handler});
}
