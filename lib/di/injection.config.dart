// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tap/di/modules.dart' as _i141;
import 'package:tap/repositories/bond_repository.dart' as _i814;
import 'package:tap/services/detail_api_service.dart' as _i48;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.listDio,
      instanceName: 'listApi',
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.detailDio,
      instanceName: 'detailApi',
    );
    gh.factory<_i48.ApiService>(
      () => _i48.ApiServiceImpl(
        gh<_i361.Dio>(instanceName: 'listApi'),
        gh<_i361.Dio>(instanceName: 'detailApi'),
      ),
    );
    gh.lazySingleton<_i814.BondRepository>(
      () => _i814.BondRepositoryImpl(gh<_i48.ApiService>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i141.NetworkModule {}
