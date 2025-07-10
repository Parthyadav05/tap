import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/network_constant.dart';


@module
abstract class NetworkModule {
  /// List API
  @lazySingleton
  @Named('listApi')
  Dio get listDio => Dio(BaseOptions(
    baseUrl: ApiConstants.listBase,
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  /// Detail API
  @lazySingleton
  @Named('detailApi')
  Dio get detailDio => Dio(BaseOptions(
    baseUrl: ApiConstants.detailBase,
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));
}
