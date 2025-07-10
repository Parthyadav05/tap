import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bond_detail.dart';

class BondDetailScreen extends StatefulWidget {
  final BondDetail detail;
  const BondDetailScreen({super.key, required this.detail});

  @override
  State<BondDetailScreen> createState() => _BondDetailScreenState();
}

class _BondDetailScreenState extends State<BondDetailScreen>
    with TickerProviderStateMixin {
  int _selectedChart = 0;     // 0: EBITDA, 1: Revenue
  int _selectedSection = 0;   // 0: ISIN Answers, 1: Pros & Cons

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: width * 0.09,
              height: width * 0.09,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F525866),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/ArrowLeft.svg',
                  width: width * 0.07,
                  height: width * 0.07,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: width * 0.03),
            // Logo
            Row(
              children: [
                Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.018),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.025),
                      child: Image.network(detail.logo, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: width * 0.04),
            // Company name & description
            Text(
              detail.companyName,
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1e2939),
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              detail.description,
              style: TextStyle(
                fontSize: width * 0.031,
                fontWeight: FontWeight.w400,
                color: const Color(0xff6a7282),
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: width * 0.03),
            // ISIN & status badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x1F2563EB),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'ISIN: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                          fontSize: width * 0.035,
                        ),
                      ),
                      Text(
                        detail.isin,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                          fontSize: width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.04),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x14059669),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    detail.status,
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: width * 0.025),
            // Section toggle: ISIN Answers / Pros & Cons
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xff4a5565), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedSection = 0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: _selectedSection == 0
                            ? const Border(
                            bottom: BorderSide(width: 2, color: Color(0xFF1447E6)))
                            : null,
                      ),
                      child: Text(
                        "ISIN Answers",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w500,
                          color: _selectedSection == 0
                              ? const Color(0xFF1447E6)
                              : const Color(0xff6a7282),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedSection = 1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: _selectedSection == 1
                            ? const Border(
                            bottom: BorderSide(width: 2, color: Color(0xFF1447E6)))
                            : null,
                      ),
                      child: Text(
                        "Pros & Cons",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w500,
                          color: _selectedSection == 1
                              ? const Color(0xFF1447E6)
                              : const Color(0xff6a7282),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conditional content
            if (_selectedSection == 0) ...[
              SizedBox(height: width * 0.05),
              // Company Financials + chart toggle
              Container(
                padding: EdgeInsets.all(width * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffe7e5e4), width: 1),
                ),
                child: Column(
                  children: [
                    // Header with segment control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'COMPANY FINANCIALS',
                          style: TextStyle(
                            color: const Color(0xffa3a3a3),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _selectedChart = 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration: BoxDecoration(
                                    color: _selectedChart == 0 ? Colors.white : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(18),
                                    ),
                                    border: _selectedChart == 0
                                        ? Border.all(color: const Color(0xFFE0E0E0), width: 1)
                                        : null,
                                  ),
                                  child: Text(
                                    "EBITDA",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedChart == 0
                                          ? Colors.black
                                          : const Color(0xFF6A7282),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _selectedChart = 1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: const EdgeInsets.only(left: 1),
                                  decoration: BoxDecoration(
                                    color: _selectedChart == 1 ? Colors.white : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(18),
                                    ),
                                    border: _selectedChart == 1
                                        ? Border.all(color: const Color(0xFFE0E0E0), width: 1)
                                        : null,
                                  ),
                                  child: Text(
                                    "Revenue",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedChart == 1
                                          ? Colors.black
                                          : const Color(0xFF6A7282),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: width * 0.03),
                    // Bar chart
                    SizedBox(
                      height: width * 0.45,
                      width: double.infinity,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 36,
                                getTitlesWidget: (value, _) => Text(
                                  '₹${(value / 1000000).round()}L',
                                  style: const TextStyle(
                                      color: Color(0xff6a7282), fontSize: 10),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (v, _) {
                                  final items = _selectedChart == 0
                                      ? detail.financials.ebitda
                                      : detail.financials.revenue;
                                  final i = v.toInt();
                                  if (i >= 0 && i < items.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        items[i].month[0].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xff6a7282)),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          maxY: (_selectedChart == 0
                              ? detail.financials.ebitda
                              : detail.financials.revenue)
                              .map((e) => e.value)
                              .reduce((a, b) => a > b ? a : b) *
                              1.2,
                          barGroups: List.generate(
                            (_selectedChart == 0
                                ? detail.financials.ebitda
                                : detail.financials.revenue)
                                .length,
                                (i) {
                              final val = _selectedChart == 0
                                  ? detail.financials.ebitda[i].value
                                  : detail.financials.revenue[i].value;
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: val.toDouble(),
                                    color: _selectedChart == 0
                                        ? Colors.black87
                                        : const Color(0xFF2BA0FF),
                                    width: 12,
                                    borderRadius: BorderRadius.circular(4),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: (_selectedChart == 0
                                          ? detail.financials.ebitda
                                          : detail.financials.revenue)
                                          .map((e) => e.value)
                                          .reduce((a, b) => a > b ? a : b) *
                                          1.2,
                                      color: _selectedChart == 0
                                          ? const Color(0xff155dfc).withOpacity(0.2)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.09),
              // Issuer Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.03),
                  border: Border.all(color: const Color(0xffe5e7eb), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/AddressBook.svg'),
                        const SizedBox(width: 6),
                        Text(
                          'Issuer Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff020617),
                            fontSize: width * 0.045,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 1.12, // slightly more than 1 to overflow padding
                        child: Container(
                          height: 1,
                          color: Color(0xffe5e7eb),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.06*width,),

                    _issuerField(
                        'Issuer Name', detail.issuerDetails.issuerName, true),
                    _issuerField(
                        'Type of Issuer', detail.issuerDetails.typeOfIssuer),
                    _issuerField('Sector', detail.issuerDetails.sector),
                    _issuerField('Industry', detail.issuerDetails.industry),
                    _issuerField(
                        'Issuer Nature', detail.issuerDetails.issuerNature),
                    _issuerField('Corporate Identity Number (CIN)',
                        detail.issuerDetails.cin),
                    _issuerField('Name of the Lead Manager',
                        detail.issuerDetails.leadManager),
                    _issuerField('Registrar', detail.issuerDetails.registrar,
                        true),
                    _issuerField('Name of Debenture Trustee',
                        detail.issuerDetails.debentureTrustee, true),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(height: width * 0.05),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffe5e7eb), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pros and Cons',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff111827),
                      ),
                    ),
                    SizedBox(height: width * 0.03),

                    // Pros
                    Text(
                      'Pros',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff059669),
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    ...detail.prosAndCons.pros.map((p) => Padding(
                      padding: EdgeInsets.only(bottom: width * 0.03),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.009),
                            height: width * 0.06,
                            width: width * 0.06,
                            decoration: BoxDecoration(
                              color: Color(0x1F16A34A),
                              borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                            child: SvgPicture.asset(
                              'assets/check.svg',
                              height: width * 0.03,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p,
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Color(0xff111827),
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                    SizedBox(height: width * 0.05),

                    // Cons
                    Text(
                      'Cons',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffb45309),
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    ...detail.prosAndCons.cons.map((c) => Padding(
                      padding: EdgeInsets.only(bottom: width * 0.03),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.009),
                            height: width * 0.06,
                            width: width * 0.06,
                            decoration: BoxDecoration(
                              color: Color(0x1FD97706),
                              borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                            child: SvgPicture.asset(
                              'assets/ExclamationMark.svg',
                              height: width * 0.03,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              c,
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Color(0xff111827),
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
            SizedBox(height: width * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _issuerField(String label, String value, [bool highlight = false]) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff1d4ed8),
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value == '-' ? '—' : value,
            style: TextStyle(
              color: highlight ? const Color(0xff111827) : const Color(0xff1e2939),
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(height: width * 0.09),
        ],
      ),
    );
  }
}
