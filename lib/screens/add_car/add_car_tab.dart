import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/lang_store.dart';
import '../../widgets/shared_widgets.dart';
import 'step1_category.dart';
import 'step2_details.dart';
import 'step3_media.dart';
import 'step4_price.dart';
import 'step5_review.dart';

/// 5-step listing wizard. State lives in addCarStepNotifier (top-level)
/// so MainShell's PopScope can decrement step on hardware back.
class AddCarTab extends StatefulWidget {
  const AddCarTab({super.key});
  @override State<AddCarTab> createState() => _AddState();
}
class _AddState extends State<AddCarTab> {
  static const _total = 5;
  String _cat = 'used';
  String _cond = 'clean';
  String _priceCur = 'USD';

  int get _step => addCarStepNotifier.value;
  set _step(int v) => addCarStepNotifier.value = v;

  @override
  void initState() {
    super.initState();
    langNotifier.addListener(_r);
    addCarStepNotifier.addListener(_r); // rebuild when step changes from outside (PopScope decrement)
  }
  @override
  void dispose() {
    langNotifier.removeListener(_r);
    addCarStepNotifier.removeListener(_r);
    super.dispose();
  }
  void _r() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header + progress bar
      Container(color: Colors.white, child: SafeArea(bottom: false, child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 6), child: Row(children: [
          if (_step > 0) GestureDetector(onTap: () => _step = _step - 1,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20)),
          if (_step > 0) const SizedBox(width: 8),
          Expanded(child: Text(T.g('add_car_title'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.navy))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${T.g('step')} ${_step + 1} ${T.g('of')} $_total',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.primary))),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: (_step + 1) / _total,
              backgroundColor: C.border, color: C.primary, minHeight: 5))),
      ]))),
      // Step body
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _body())),
      // Bottom button
      Container(padding: const EdgeInsets.fromLTRB(16, 10, 16, 28), color: Colors.white,
        child: _step < _total - 1
          ? PriBtn(label: T.g('next'),    onTap: () => _step = _step + 1)
          : PriBtn(label: T.g('confirm'), onTap: () => _step = 0)),
    ]);
  }

  Widget _body() {
    switch (_step) {
      case 0: return Step1Cat(cat: _cat, onChanged: (v) => setState(() => _cat = v));
      case 1: return Step2Details(cat: _cat, cond: _cond, onCond: (v) => setState(() => _cond = v));
      case 2: return const Step3Media();
      case 3: return Step4Price(cur: _priceCur, onCur: (v) => setState(() => _priceCur = v));
      case 4: return Step5Review(cat: _cat, cur: _priceCur);
      default: return const SizedBox();
    }
  }
}
