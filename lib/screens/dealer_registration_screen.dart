import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../widgets/shared_widgets.dart';

class DealerRegistrationScreen extends StatefulWidget {
  const DealerRegistrationScreen({super.key});
  @override State<DealerRegistrationScreen> createState() => _DealerRegState();
}
class _DealerRegState extends State<DealerRegistrationScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _taxCtrl = TextEditingController();
  String _city = 'Baghdad';
  bool _hasLicense = false;
  bool _agreeTos = false;
  bool _submitted = false;

  final List<String> _cities = ['Baghdad', 'Erbil', 'Sulaymaniyah', 'Duhok', 'Kirkuk', 'Basra', 'Mosul', 'Najaf'];

  @override void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _emailCtrl.dispose();
    _addressCtrl.dispose(); _licenseCtrl.dispose(); _taxCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    if (_submitted) return _SuccessPage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dealer Registration', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white, foregroundColor: C.navy, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.primary, theme.primaryDk]),
              borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28)),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Dealer / Showroom Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                SizedBox(height: 2),
                Text('Verified business listing with dedicated profile page, full inventory grid, and reel showcase.',
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
              ])),
            ])),
          const SizedBox(height: 20),
          _section('Business Information'),
          const SizedBox(height: 12),
          _field('Showroom / Dealership Name *', Icons.business_rounded, _nameCtrl),
          const SizedBox(height: 10),
          _field('Business Phone *', Icons.phone_rounded, _phoneCtrl, type: TextInputType.phone),
          const SizedBox(height: 10),
          _field('Business Email *', Icons.email_rounded, _emailCtrl, type: TextInputType.emailAddress),
          const SizedBox(height: 10),
          _field('Full Address *', Icons.location_on_rounded, _addressCtrl),
          const SizedBox(height: 10),
          // City dropdown
          Container(padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.border)),
            child: Row(children: [
              Icon(Icons.location_city_rounded, color: theme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(child: DropdownButton<String>(
                value: _city, isExpanded: true, underline: const SizedBox(),
                items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _city = v!),
              )),
            ])),
          const SizedBox(height: 20),
          _section('Verification Documents'),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200)),
            child: const Row(children: [
              Icon(Icons.verified_user_rounded, color: Colors.amber, size: 16),
              SizedBox(width: 8),
              Expanded(child: Text('Documents are reviewed by CarPro team to verify your business.',
                style: TextStyle(fontSize: 11, color: C.textSub))),
            ])),
          const SizedBox(height: 12),
          _field('Trade License Number *', Icons.badge_rounded, _licenseCtrl),
          const SizedBox(height: 10),
          _field('Tax Registration Number', Icons.receipt_long_rounded, _taxCtrl),
          const SizedBox(height: 10),
          // Upload license
          GestureDetector(
            onTap: () => setState(() => _hasLicense = true),
            child: Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _hasLicense ? Colors.green.shade50 : const Color(0xFFF4F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _hasLicense ? Colors.green.shade300 : C.border, width: _hasLicense ? 1.5 : 1)),
              child: Row(children: [
                Icon(_hasLicense ? Icons.check_circle_rounded : Icons.upload_file_rounded,
                  color: _hasLicense ? Colors.green.shade600 : theme.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_hasLicense ? 'License document uploaded ✓' : 'Upload Trade License (PDF/Image)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: _hasLicense ? Colors.green.shade700 : C.textMain)),
                  if (!_hasLicense) const Text('Required for verification', style: TextStyle(fontSize: 11, color: C.textSub)),
                ])),
              ])),
          ),
          const SizedBox(height: 20),
          _section('Dealer Profile Setup'),
          const SizedBox(height: 12),
          // Cover photo
          Container(height: 100, decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.primary.withOpacity(0.2), style: BorderStyle.solid)),
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate_rounded, color: theme.primary, size: 30),
              const SizedBox(height: 4),
              Text('Upload Cover Photo', style: TextStyle(color: theme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              const Text('Recommended: 1200×400px', style: TextStyle(color: C.textSub, fontSize: 10)),
            ]))),
          const SizedBox(height: 20),
          // Terms
          GestureDetector(
            onTap: () => setState(() => _agreeTos = !_agreeTos),
            child: Row(children: [
              AnimatedContainer(duration: const Duration(milliseconds: 150),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: _agreeTos ? theme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: _agreeTos ? theme.primary : C.border, width: 1.5)),
                child: _agreeTos ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null),
              const SizedBox(width: 10),
              const Expanded(child: Text('I agree to CarPro Dealer Terms & Conditions and confirm all information is accurate.',
                style: TextStyle(fontSize: 12, color: C.textSub, height: 1.4))),
            ])),
          const SizedBox(height: 24),
          PriBtn(
            label: 'Submit Dealer Application',
            onTap: (_agreeTos && _hasLicense) ? () => setState(() => _submitted = true) : null),
          const SizedBox(height: 8),
          if (!_agreeTos || !_hasLicense)
            Center(child: Text('Please upload license document and agree to terms',
              style: const TextStyle(fontSize: 11, color: C.textSub))),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _section(String title) => Text(title,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: C.navy));

  Widget _field(String hint, IconData icon, TextEditingController ctrl, {TextInputType? type}) =>
    TextField(controller: ctrl, keyboardType: type,
      decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(color: C.textSub, fontSize: 13),
        prefixIcon: Icon(icon, color: C.primary, size: 20),
        filled: true, fillColor: const Color(0xFFF4F7FF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.primary, width: 1.8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)));
}

class _SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 80, height: 80,
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 50)),
          const SizedBox(height: 24),
          const Text('Application Submitted!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: C.navy)),
          const SizedBox(height: 12),
          const Text('Your dealer application has been submitted.\nOur team will review it within 24–48 hours.\nYou will receive a notification once approved.',
            style: TextStyle(fontSize: 14, color: C.textSub, height: 1.6), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          PriBtn(label: 'Back to Home', onTap: () => Navigator.of(context).popUntil((r) => r.isFirst)),
        ]))));
  }
}
