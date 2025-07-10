import 'package:injectable/injectable.dart';
import '../models/bond_summary.dart';
import '../models/bond_detail.dart';
import '../services/detail_api_service.dart';


abstract class BondRepository {
  Future<List<BondSummary>> getAllBonds();
  Future<BondDetail> getBondByIsin(String isin);
}

@LazySingleton(as: BondRepository)
class BondRepositoryImpl implements BondRepository {
  final ApiService _apiService;
  BondRepositoryImpl(this._apiService);

  @override
  Future<List<BondSummary>> getAllBonds() => _apiService.fetchBondSummaries();

  @override
  Future<BondDetail> getBondByIsin(String isin) => _apiService.fetchBondDetail(isin);
}
