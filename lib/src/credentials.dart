@JS()
library web3dart.internal.js.creds;

import 'dart:typed_data';

import 'package:js/js.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

import 'dart_wrappers.dart';
import 'javascript.dart';

class MetaMaskCredentials extends CredentialsWithKnownAddress
    implements CustomTransactionSender {
  MetaMaskCredentials(String hexAddress, this.ethereum)
      : address = EthereumAddress.fromHex(hexAddress);

  @override
  final EthereumAddress address;
  final Ethereum ethereum;

  @override
  Future<MsgSignature> signToSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) {
    throw UnsupportedError('Signing raw payloads is not supported on MetaMask');
  }

  @override
  Future<Uint8List> signPersonalMessage(Uint8List payload, {int? chainId}) {
    return ethereum.rawRequest(
      'eth_sign',
      params: [
        address.hex,
        _bytesToData(payload),
      ],
    ).then(_responseToBytes);
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final param = _TransactionParameters(
      from: (transaction.from ?? address).hex,
      to: transaction.to?.hex,
      gasPrice: _bigIntToQuantity(transaction.gasPrice?.getInWei),
      gas: _intToQuantity(transaction.maxGas),
      value: _bigIntToQuantity(transaction.value?.getInWei),
      data: _bytesToData(transaction.data),
    );

    final res = await ethereum.rawRequest(
      'eth_sendTransaction',
      params: [param],
    );

    return res as String;
  }
}

String? _bigIntToQuantity(BigInt? int) {
  return int != null ? '0x${int.toRadixString(16)}' : null;
}

String? _intToQuantity(int? int) {
  return int != null ? '0x${int.toRadixString(16)}' : null;
}

Uint8List _responseToBytes(dynamic response) {
  return hexToBytes(response as String);
}

String? _bytesToData(Uint8List? data) {
  return data != null
      ? bytesToHex(data, include0x: true, padToEvenLength: true)
      : null;
}

@JS()
@anonymous
class _TransactionParameters {
  external factory _TransactionParameters({
    required String from,
    String? gas,
    String? gasPrice,
    String? to,
    String? value,
    String? data,
  });

  external String? get gasPrice;
  external String? get gas;
  external String? get to;
  external String get from;
  external String? get value;
  external String? get data;
}
