import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/network_constant.dart';


@module
abstract class NetworkModule {
  @lazySingleton @Named('listApi')
  Dio get listDio => Dio(BaseOptions(baseUrl: ApiConstants.listBase));
  @lazySingleton @Named('detailApi')
  Dio get detailDio => Dio(BaseOptions(baseUrl: ApiConstants.detailBase));
}


