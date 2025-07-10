import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap/di/injection.dart';
import '../bloc/bloc_cubit.dart';
import '../bloc/bond_state.dart';
import '../models/bond_detail.dart';
import '../repositories/bond_repository.dart';
import 'bond_detail_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  BondDetail? _commonDetail;
  bool _loadingDetail = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final horizontalPadding = width * 0.04;
    final verticalPadding = height * 0.02;
    final elementSpacing = height * 0.025;
    final avatarSize = width * 0.15;
    final borderPadding = width * 0.015;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search by Issuer Name or ISIN',
                  hintStyle: TextStyle(color: Color(0xFF99A1AF), fontSize: width * 0.035),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF6A7282)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: verticalPadding / 2, horizontal: horizontalPadding),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    borderSide: BorderSide(width: 0.5, color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    borderSide: BorderSide(width: 0.5, color: Color(0xFFE5E7EB)),
                  ),
                ),
                onChanged: (v) {
                  HapticFeedback.lightImpact();
                  setState(() => _searchQuery = v);
                },
              ),
            ),
            SizedBox(height: elementSpacing * 1.2),
            // Label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                _searchQuery.isEmpty ? 'SUGGESTED RESULTS' : 'SEARCH RESULTS',
                style: TextStyle(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF99A1AF),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: verticalPadding * 0.6),
            // Results Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: BlocBuilder<BondCubit, BondState>(
                builder: (ctx, state) {
                  if (state is BondStateLoading) {
                    return Center(
                      child: SizedBox(
                        width: width * 0.1,
                        height: width * 0.1,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is BondStateLoaded) {
                    final matches = state.bonds.where((b) {
                      final q = _searchQuery.toLowerCase();
                      return b.companyName.toLowerCase().contains(q) ||
                          b.isin.toLowerCase().contains(q);
                    }).toList();

                    if (matches.isEmpty) {
                      HapticFeedback.mediumImpact();
                      return Padding(
                        padding: EdgeInsets.only(top: verticalPadding * 2),
                        child: Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(fontSize: width * 0.045, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(width: 0.5, color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: matches.map((bond) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: elementSpacing),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: verticalPadding / 2,
                                horizontal: horizontalPadding / 2,
                              ),
                              onTap: () async {
                                if (_commonDetail == null && !_loadingDetail) {
                                  setState(() => _loadingDetail = true);
                                  try {
                                    final repo = getIt<BondRepository>();          // <<-- use getIt
                                    final detail = await repo.getBondDetail();     // no parameter
                                    setState(() => _commonDetail = detail);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to fetch detail')),
                                    );
                                  } finally {
                                    setState(() => _loadingDetail = false);
                                  }
                                }
                                if (_commonDetail != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BondDetailScreen(detail: _commonDetail!),
                                    ),
                                  );
                                }
                              },



                              leading: Container(
                                width: avatarSize,
                                height: avatarSize,
                                padding: EdgeInsets.all(borderPadding),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.grey.shade300),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    bond.logo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: _highlightTextWithIsin(
                                bond.isin, _searchQuery, width,
                              ),
                              subtitle: _highlightText(
                                '${bond.rating} • ${bond.companyName}', _searchQuery, width,
                              ),
                              trailing: Icon(Icons.chevron_right,
                                  size: width * 0.06, color: Color(0xFF1447E6)),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  if (state is BondStateError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _highlightText(String text, String query, double width) {
    final baseStyle = TextStyle(
      fontSize: width * 0.035,
      fontWeight: FontWeight.w500,
      color: Color(0xFF6A7282),
      height: 1.2,
    );
    if (query.isEmpty) return Text(text, style: baseStyle);

    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    List<InlineSpan> spans = [];
    int start = 0;
    while (true) {
      final i = lower.indexOf(q, start);
      if (i < 0) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }
      if (i > start) {
        spans.add(TextSpan(text: text.substring(start, i), style: baseStyle));
      }
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(

          decoration: BoxDecoration(
            color: Color(0x29D97706),
            borderRadius: BorderRadius.circular(width * 0.007),
          ),
          child: Text(
            text.substring(i, i + q.length),
            style: baseStyle,
          ),
        ),
      ));
      start = i + q.length;
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _highlightTextWithIsin(String isin, String query, double width) {
    final before = isin.substring(0, isin.length - 4);
    final after = isin.substring(isin.length - 4);
    final beforeStyle = TextStyle(
      fontSize: width * 0.04,
      fontWeight: FontWeight.w600,
      color: Color(0xff6a7282),
      height: 1.2,
    );
    final afterStyle = TextStyle(
      fontSize: width * 0.045,
      fontWeight: FontWeight.w600,
      color: Color(0xff1e2939),
      height: 1.2,
    );

    if (query.isNotEmpty) {
      final isinLower = isin.toLowerCase();
      final queryLower = query.toLowerCase();
      final idx = isinLower.indexOf(queryLower);
      if (idx >= 0) {
        List<InlineSpan> spans = [];
        for (int i = 0; i < isin.length;) {
          if (isinLower.startsWith(queryLower, i)) {
            final isAfter = i + query.length > isin.length - 4;
            spans.add(WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x29D97706),
                  borderRadius: BorderRadius.circular(width * 0.007),
                ),
                child: Text(
                  isin.substring(i, i + query.length),
                  style: isAfter ? afterStyle : beforeStyle,
                ),
              ),
            ));
            i += query.length;
          } else {
            final isAfter = i >= isin.length - 4;
            spans.add(TextSpan(
              text: isin[i],
              style: isAfter ? afterStyle : beforeStyle,
            ));
            i++;
          }
        }
        return RichText(text: TextSpan(children: spans));
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: before, style: beforeStyle),
          TextSpan(text: after, style: afterStyle),
        ],
      ),
    );
  }

}
