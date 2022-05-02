@JS()
library web3dart.internal.js;

import 'dart:html';

import 'package:js/js.dart';

import 'dart_wrappers.dart';

@JS('ethereum')
external Ethereum? get _ethereum;

/// Extension to load obtain the `ethereum` window property injected by
/// Ethereum browser plugins.
extension GetEthereum on Window {
  /// Loads the ethereum instance provided by the browser.
  ///
  /// For more information on how to use this object with the web3dart package,
  /// see the methods on [DartEthereum].
  Ethereum? get ethereum => _ethereum;
}

@JS()
class Ethereum {
  external bool get isMetaMask;
  external int get chainId;
  external bool autoRefreshOnNetworkChange;
  external bool isConnected();

  /// This should not be used in user code. Use `stream(event)` instead.
  external void on(String event, Function callback);

  /// This should not be used in user code. Use `stream(event)` instead.
  external void removeListener(String event, Function callback);

  /// This should not be used in user code. Use `requestRaw` instead.
  external Object request(RequestArguments args);
}

@JS()
@anonymous
class RequestArguments {
  external factory RequestArguments({required String method, Object? params});

  external String get method;
  external Object? get params;
}
