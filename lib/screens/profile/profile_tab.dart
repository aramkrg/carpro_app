import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/auth.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/lang_store.dart';
import '../../core/theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/login_wall.dart';
import '../language_screen.dart';
import '../phone_screen.dart';
import '../tools/tools_screen.dart';
import 'theme_screen.dart';
import 'wallet_screen.dart';
import 'notifications_screen.dart';
import 'my_listings_screen.dart';
import 'favorites_screen.dart';
import 'placeholder_screen.dart';
import '../dealers_directory_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override State<ProfileTab> createState() => _ProfState();
}
class _ProfState extends State<ProfileTab> {
  @override void initState() {
    super.initState();
    langNotifier.addListener(_r);
    authNotifier.addListener(_r);
    themeNotifier.addListener(_r);
  }
  @override void dispose() {
    langNotifier.removeListener(_r);
    authNotifier.removeListener(_r);
    themeNotifier.removeListener(_r);
    super.dispose();
  }
  void _r() => setState(() {});

  void _confirmSignOut() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(T.g('sign_out')),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(onPressed: () { AuthService.signOut(); Navigator.pop(ctx); },
          child: Text(T.g('sign_out'), style: const TextStyle(color: C.red, fontWeight: FontWeight.w700))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.current;
    final pri = ThemeManager.active.primary;

    return Column(children: [
      AppBar2(title: T.g('profile')),
      Expanded(child: ListView(padding: const EdgeInsets.all(14), children: [
        // Profile card
        Container(padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: pri.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 5))]),
          child: user == null ? _GuestProfileCard(pri: pri) : _LoggedInProfileCard(user: user, pri: pri)),
        const SizedBox(height: 12),
        // Stats row
        Row(children: [
          _Stat('${user?.myListingIds.length ?? 0}', T.g('my_listings'), Icons.directions_car_rounded),
          const SizedBox(width: 8),
          _Stat('${user?.favoriteCarIds.length ?? 0}', T.g('favorites'), Icons.favorite_rounded),
          const SizedBox(width: 8),
          _Stat('0', T.g('msgs'), Icons.chat_bubble_rounded),
        ]),
        const SizedBox(height: 12),

        // ── Dealers Directory button ─────────────────────────────────
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DealersDirectoryScreen())),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [pri, pri.withOpacity(0.8)],
                begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: pri.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 24)),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Browse Dealers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 2),
                Text('Verified showrooms & dealerships near you', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ])),
              Container(padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)),
            ]))),
        const SizedBox(height: 12),

        // ── Account menu ─────────────────────────────────────────────
        _SectionLabel('My Account'),
        const SizedBox(height: 8),
        Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(children: [
            _MI(Icons.directions_car_outlined, T.g('my_listings'),
              onTap: () => requireLogin(context, () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyListingsScreen())),
                reason: 'See and manage your car listings')),
            _MI(Icons.favorite_outline_rounded, T.g('favorites'),
              onTap: () => requireLogin(context, () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                reason: 'See your saved cars')),
            _MI(Icons.chat_bubble_outline_rounded, T.g('msgs'),
              onTap: () => requireLogin(context, () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagesPlaceholder())),
                reason: 'Chat with sellers')),
            _MI(Icons.account_balance_wallet_outlined, T.g('wallet'),
              onTap: () => requireLogin(context, () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen())),
                reason: 'Manage your wallet')),
            _MI(Icons.notifications_outlined, T.g('notifications'), last: true,
              onTap: () => requireLogin(context, () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                reason: 'See updates')),
          ])),
        const SizedBox(height: 12),

        // REQ 9: Tools section INSIDE profile
        _SectionLabel('Tools & Utilities'),
        const SizedBox(height: 8),
        Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(children: [
            _MI(Icons.calculate_outlined, 'Car Loan Calculator',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsScreen()))),
            _MI(Icons.local_gas_station_outlined, 'Fuel Cost Calculator',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsScreen()))),
            _MI(Icons.document_scanner_outlined, 'VIN Check',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsScreen()))),
            _MI(Icons.handyman_outlined, 'All Tools', last: true,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsScreen()))),
          ])),
        const SizedBox(height: 12),

        // ── Settings ─────────────────────────────────────────────────
        _SectionLabel('Settings'),
        const SizedBox(height: 8),
        Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(children: [
            _MI(Icons.language_outlined, T.g('language'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen(fromProfile: true)))),
            if (AppFlags.themesEnabled) _MI(Icons.palette_outlined, 'Theme',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ThemeScreen()))),
            _MI(Icons.shield_outlined, T.g('privacy'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Privacy & Security')))),
            _MI(Icons.help_outline_rounded, T.g('help'), last: user == null,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Help & Support')))),
            if (user != null)
              _MI(Icons.logout_rounded, T.g('sign_out'), red: true, last: true, onTap: _confirmSignOut)
            else
              _MI(Icons.login_rounded, 'Sign In', last: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhoneScreen()))),
          ])),
        const SizedBox(height: 20),
      ])),
    ]);
  }
}

class _SectionLabel extends StatelessWidget {
  final String t;
  const _SectionLabel(this.t);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 2),
    child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: C.textSub,
      letterSpacing: 0.5, textBaseline: TextBaseline.alphabetic)));
}

class _GuestProfileCard extends StatelessWidget {
  final Color pri;
  const _GuestProfileCard({required this.pri});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [
      CircleAvatar(radius: 32, backgroundColor: pri.withOpacity(0.1),
        child: Icon(Icons.person_outline_rounded, color: pri, size: 34)),
      const SizedBox(width: 14),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Guest', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
        SizedBox(height: 2),
        Text('Sign in to post cars, save favorites, and message sellers',
          style: TextStyle(fontSize: 12, color: C.textSub, height: 1.4)),
      ])),
    ]),
    const SizedBox(height: 14),
    Row(children: [
      Expanded(child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhoneScreen())),
        icon: const Icon(Icons.login_rounded, size: 16),
        label: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(backgroundColor: ThemeManager.active.primary, foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0))),
      const SizedBox(width: 8),
      Expanded(child: OutlinedButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhoneScreen())),
        icon: const Icon(Icons.person_add_outlined, size: 16),
        label: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(foregroundColor: ThemeManager.active.primary,
          side: BorderSide(color: ThemeManager.active.primary),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
    ]),
  ]);
}

class _LoggedInProfileCard extends StatelessWidget {
  final CarProUser user; final Color pri;
  const _LoggedInProfileCard({required this.user, required this.pri});
  @override
  Widget build(BuildContext context) {
    final since = '${_monthName(user.joinedAt.month)} ${user.joinedAt.year}';
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
    return Row(children: [
      Stack(children: [
        CircleAvatar(radius: 32, backgroundColor: pri.withOpacity(0.12),
          child: Text(initial, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: pri))),
        Positioned(right: 0, bottom: 0, child: Container(width: 22, height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: pri),
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12))),
      ]),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(user.name.isEmpty ? 'No name set' : user.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
        const SizedBox(height: 2),
        Text(user.phone, style: const TextStyle(fontSize: 13, color: C.textSub)),
        const SizedBox(height: 2),
        Text('Member since $since', style: const TextStyle(fontSize: 11, color: C.textSub)),
      ])),
    ]);
  }
  static String _monthName(int m) =>
    ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

class _Stat extends StatelessWidget {
  final String n, label; final IconData icon;
  const _Stat(this.n, this.label, this.icon);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
    child: Column(children: [
      Icon(icon, color: C.primary, size: 20),
      const SizedBox(height: 4),
      Text(n, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: C.navy)),
      Text(label, style: const TextStyle(fontSize: 10, color: C.textSub), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
    ])));
}

class _MI extends StatelessWidget {
  final IconData icon; final String label;
  final bool red, last; final VoidCallback? onTap;
  const _MI(this.icon, this.label, {this.red = false, this.last = false, this.onTap});
  @override
  Widget build(BuildContext context) => Column(children: [
    InkWell(onTap: onTap ?? () {}, borderRadius: BorderRadius.circular(12),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(children: [
          Icon(icon, size: 20, color: red ? C.red : C.primary),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
            color: red ? C.red : C.textMain))),
          if (!red) const Icon(Icons.chevron_right_rounded, color: Color(0xFFCCD4E8), size: 18),
        ]))),
    if (!last) const Divider(height: 1, indent: 16, endIndent: 16, color: C.border),
  ]);
}
