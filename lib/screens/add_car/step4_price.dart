import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/currency_toggle.dart';

/// Step 4 of Add Car wizard: price (USD/IQD toggle), description, installments.
class Step4Price extends StatelessWidget {
  final String cur;
  final ValueChanged<String> onCur;
  const Step4Price({super.key, required this.cur, required this.onCur});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      FL(T.g('price')),
      // Seller chooses IQD or USD
      CurrToggle(val: cur, onChanged: onCur),
    ]),
    const SizedBox(height: 6),
    IFld(hint: cur == 'USD' ? '\$ Enter price in USD' : 'Enter price in IQD',
      icon: Icons.attach_money_rounded, kbType: TextInputType.number),
    const SizedBox(height: 4),
    Text(T.g('rate_label').replaceAll('{rate}', AppFlags.usdToIqd.toInt().toString()),
      style: const TextStyle(fontSize: 11, color: C.textSub)),
    const SizedBox(height: 16),
    FL(T.g('desc')), const SizedBox(height: 8),
    TextField(maxLines: 4, decoration: InputDecoration(
      hintText: 'Describe the car condition, history, features…',
      hintStyle: const TextStyle(color: Color(0xFFBBC4D8), fontSize: 13),
      filled: true, fillColor: const Color(0xFFF4F7FF),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.primary, width: 1.8)))),
    if (AppFlags.autoTranslate) ...[
      const SizedBox(height: 8),
      Align(alignment: Alignment.centerRight, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.translate_rounded, color: C.primary, size: 14),
          const SizedBox(width: 4),
          Text(T.g('translate'), style: const TextStyle(fontSize: 12, color: C.primary, fontWeight: FontWeight.w600)),
        ]))),
    ],
    if (AppFlags.installments) ...[
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
        child: Row(children: [
          const Icon(Icons.payment_rounded, color: C.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(T.g('installments'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Switch(value: false, onChanged: (_) {}, activeThumbColor: C.primary),
        ])),
    ],
  ]);
}

// Backward-compat alias
typedef _Step4Price = Step4Price;
