import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'models/block.dart';

const API_HOST = 'localhost';
//const API_HOST = '10.0.2.2';
const API_PORT = '9090';
const API_BASE_URL = 'http://$API_HOST:$API_PORT';

final client = APIClient();

class GenericResponse {
  late int statusCode;

  GenericResponse(this.statusCode);

  GenericResponse.fromResponse(Response response) {
    statusCode = response.statusCode!;
  }
}

class BlocksListResponse extends GenericResponse {
  List<Block> blocks = [];

  BlocksListResponse(statusCode, this.blocks) : super(statusCode);

  BlocksListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Block> _blocks = [];
    if (response.statusCode == 200) {
      jsonDecode(response.data)['block']
          .map((e) {
            return Block.fromJson(e);
          })
          .cast<Block>()
          .forEach((Block b) => _blocks.add(b));
    }
    this.blocks = _blocks;
  }
}

class BlockResponse extends GenericResponse {
  Block? block;

  BlockResponse(statusCode, this.block) : super(statusCode);

  BlockResponse.fromResponse(Response response) : super.fromResponse(response) {
    if (response.statusCode == 200) {
      this.block = Block.fromJson(jsonDecode(response.data));
    }
  }
}
class ContractDetailResponse extends GenericResponse {
  Block? block;

  ContractDetailResponse(statusCode, this.block) : super(statusCode);

  ContractDetailResponse.fromResponse(Response response) : super.fromResponse(response) {
    if (response.statusCode == 200) {
      this.block = Block.fromJson(jsonDecode(response.data));
    }
  }
}

class LatestBlockResponse extends GenericResponse {
  final Block result;

  LatestBlockResponse(statusCode, this.result) : super(statusCode);
}

class APIClient {
  late Dio _dio;

  APIClient() {
    _dio = Dio();
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.validateStatus = (status) => status! < 500;
      options.responseType = ResponseType.json;
      return handler.next(options);
    }));
  }

  void checkConnectionStatus(
      BuildContext context, Function(bool) callback) async {
    try {
      await http.get(Uri.parse(API_BASE_URL));
      callback(true);
    } on Exception {
      callback(false);
    }
  }

  void getBlocks(BuildContext context, start,
      Function(BlocksListResponse) callback) async {
    final end = start + 10;
    return _dio
        .get(
            API_BASE_URL +
                "/wallet/getblockbylimitnext?startNum=$start&endNum=$end",
            options: Options(validateStatus: (status) => status! < 500))
        .then((response) {
      callback(BlocksListResponse.fromResponse(response));
      return response;
    });
  }

  void getNowBlock(
      BuildContext context, Function(BlockResponse) callback) async {
    return _dio.get(API_BASE_URL + "/wallet/getnowblock").then((response) {
      callback(BlockResponse.fromResponse(response));
      return response;
    });
  }

  void getContractAddress(BuildContext context, contractAddress, Function(ContractDetailResponse) callback) async {
    return _dio.post(API_BASE_URL + "/wallet/deploycontract").then((response) {
      callback(ContractDetailResponse.fromResponse(response));
      return response;
    });
  }
}
