import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/bond_summary.dart';
import '../models/bond_detail.dart';

abstract class ApiService {
  Future<List<BondSummary>> fetchBondSummaries();
  Future<BondDetail> fetchBondDetail(String isin);
}

@Injectable(as: ApiService)
class ApiServiceImpl implements ApiService {
  final Dio _listDio;
  final Dio _detailDio;

  ApiServiceImpl(
      @Named('listApi') this._listDio,
      @Named('detailApi') this._detailDio,
      );

  @override
  Future<List<BondSummary>> fetchBondSummaries() async {
    final response = await _listDio.get('/');
    final list = response.data['data'] as List;
    return list
        .map((e) => BondSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BondDetail> fetchBondDetail(String isin) async {
    final response = await _detailDio.get('/$isin');
    return BondDetail.fromJson(response.data as Map<String, dynamic>);
  }
}
