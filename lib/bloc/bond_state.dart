import '../models/bond_summary.dart';

abstract class BondState {}

class BondStateInitial extends BondState {}
class BondStateLoading extends BondState {}
class BondStateLoaded extends BondState {
  final List<BondSummary> bonds;
  BondStateLoaded(this.bonds);
}
class BondStateError extends BondState {
  final String message;
  BondStateError(this.message);
}