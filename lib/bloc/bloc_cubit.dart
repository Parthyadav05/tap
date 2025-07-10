import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../repositories/bond_repository.dart';
import 'bond_state.dart';



@injectable
class BondCubit extends Cubit<BondState> {
  final BondRepository _repository;
  BondCubit(this._repository) : super(BondStateInitial());

  Future<void> fetchBonds() async {
    emit(BondStateLoading());
    try {
      final bonds = await _repository.getAllBonds();
      emit(BondStateLoaded(bonds));
    } catch (e) {
      emit(BondStateError(e.toString()));
    }
  }
}