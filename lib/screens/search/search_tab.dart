import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/lang_store.dart';
import '../../data/sample_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/car_card.dart';
import 'filter_sheet.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});
  @override State<SearchTab> createState() => _SearchState();
}
class _SearchState extends State<SearchTab> {
  String _currency = 'USD';
  double _min = 0, _max = 200000;

  @override void initState() { super.initState(); langNotifier.addListener(_r); }
  @override void dispose()   { langNotifier.removeListener(_r); super.dispose(); }
  void _r() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    return Column(children: [
      AppBar2(title: T.g('nav_search')),
      Expanded(child: wide
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 260, child: FilterPanel(
              currency: _currency, min: _min, max: _max,
              onChanged: (c, mn, mx) => setState(() { _currency = c; _min = mn; _max = mx; }))),
            const VerticalDivider(width: 1, color: C.border),
            const Expanded(child: _CarList()),
          ])
        : Column(children: [
            _SearchBar(onFilter: () => showModalBottomSheet(context: context, isScrollControlled: true,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (_) => FilterSheet(currency: _currency, min: _min, max: _max,
                onChanged: (c, mn, mx) => setState(() { _currency = c; _min = mn; _max = mx; })))),
            const Expanded(child: _CarList()),
          ])),
    ]);
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onFilter;
  const _SearchBar({required this.onFilter});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
    child: Row(children: [
      Expanded(child: Container(height: 42,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
        child: Row(children: [
          const SizedBox(width: 10),
          const Icon(Icons.search_rounded, color: C.textSub, size: 18),
          const SizedBox(width: 6),
          Text(T.g('search_hint'), style: const TextStyle(fontSize: 13, color: Color(0xFFBBC4D8))),
        ]))),
      const SizedBox(width: 8),
      GestureDetector(onTap: onFilter, child: Container(width: 42, height: 42,
        decoration: BoxDecoration(color: C.primary, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20))),
    ]));
}

class _CarList extends StatelessWidget {
  const _CarList();
  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(14), itemCount: kCars.length,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (_, i) => CarCard(car: kCars[i], onFav: () {}));
}
