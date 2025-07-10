import 'package:freezed_annotation/freezed_annotation.dart';
part 'bond_summary.freezed.dart';
part 'bond_summary.g.dart';

@freezed
class BondSummary with _$BondSummary {
  const factory BondSummary({
    required String logo,
    required String isin,
    required String rating,
    @JsonKey(name: 'company_name') required String companyName,
    required List<String> tags,
  }) = _BondSummary;

  factory BondSummary.fromJson(Map<String, dynamic> json) =>
      _$BondSummaryFromJson(json);
}
