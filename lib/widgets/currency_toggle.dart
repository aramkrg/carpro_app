import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';

/// USD / IQD segmented toggle button.
/// Used in Search filters, Add Car price step, and Fuel cost calculator.
class CurrToggle extends StatelessWidget {
  final String val; final ValueChanged<String> onChanged;
  const CurrToggle({super.key, required this.val, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    _CTile(label: T.g('usd'), sel: val == 'USD', left: true,  onTap: () => onChanged('USD')),
    _CTile(label: T.g('iqd'), sel: val == 'IQD', left: false, onTap: () => onChanged('IQD')),
  ]);
}

class _CTile extends StatelessWidget {
  final String label; final bool sel, left; final VoidCallback onTap;
  const _CTile({required this.label, required this.sel, required this.left, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: sel ? pri : Colors.white,
        borderRadius: BorderRadius.horizontal(
          left:  left  ? const Radius.circular(6) : Radius.zero,
          right: left  ? Radius.zero : const Radius.circular(6)),
        border: Border.all(color: pri)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
        color: sel ? Colors.white : pri))));
  }
}

// Private alias for backward compatibility with screens using _CurrToggle
typedef _CurrToggle = CurrToggle;
