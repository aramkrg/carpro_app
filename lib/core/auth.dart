import 'package:flutter/foundation.dart';

// ═══════════════════════════════════════════════════════════════════
// AUTH SYSTEM (MOCK)
// Identical surface to Firebase. To switch to real Firebase later:
//   1. Add firebase_auth + cloud_firestore packages to pubspec.yaml
//   2. Replace AuthService internals with FirebaseAuth.instance calls
//   3. Replace _users map with Firestore queries
// All UI calls into AuthService stay unchanged.
// ═══════════════════════════════════════════════════════════════════

class CarProUser {
  final String uid;
  final String phone;
  String name;
  final DateTime joinedAt;
  Set<String> favoriteCarIds;     // car ids saved by this user
  List<String> myListingIds;      // ids of cars this user posted

  CarProUser({
    required this.uid,
    required this.phone,
    required this.name,
    required this.joinedAt,
    Set<String>? favoriteCarIds,
    List<String>? myListingIds,
  })  : favoriteCarIds = favoriteCarIds ?? <String>{},
        myListingIds = myListingIds ?? <String>[];
}

/// Notifies UI of login/logout. Listens via ValueListenableBuilder.
final authNotifier = ValueNotifier<CarProUser?>(null);

class AuthService {
  // Mock storage — in production this is Firestore.
  // Pre-seeded with a demo user so testing is instant.
  static final Map<String, CarProUser> _users = {
    '+9647501234567': CarProUser(
      uid: 'u_demo_1', phone: '+9647501234567', name: 'Awat Mohammad',
      joinedAt: DateTime(2024, 6, 12),
      favoriteCarIds: {'3', '6'},
      myListingIds: ['1', '5']),
  };

  // Tracks the most recent OTP request — in production Firebase handles this.
  static String? _pendingPhone;

  static const String _MOCK_OTP = '123456';

  /// Returns the current logged-in user, or null if guest.
  static CarProUser? get current => authNotifier.value;
  static bool get isLoggedIn => authNotifier.value != null;

  /// Step 1 of login. Always succeeds in mock; real Firebase sends an SMS.
  static Future<String> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _pendingPhone = phone;
    return 'mock_verification_id_for_$phone';
  }

  /// Step 2 of login. Verifies the code and signs the user in.
  /// Returns true on success, false on wrong code.
  static Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (code != _MOCK_OTP) return false;
    if (_pendingPhone == null) return false;
    final phone = _pendingPhone!;
    var user = _users[phone];
    user ??= CarProUser(
      uid: 'u_${DateTime.now().millisecondsSinceEpoch}',
      phone: phone,
      name: '',                     // empty → triggers NameEntryScreen
      joinedAt: DateTime.now());
    _users[phone] = user;
    authNotifier.value = user;
    return true;
  }

  /// Save a name for a freshly-registered user (called from NameEntryScreen).
  static void setName(String name) {
    final u = authNotifier.value;
    if (u == null) return;
    u.name = name.trim();
    authNotifier.value = u;
    // Trigger a rebuild — ValueNotifier doesn't fire for in-place mutation
    authNotifier.notifyListeners();
  }

  static void signOut() {
    _pendingPhone = null;
    authNotifier.value = null;
  }

  /// Toggle a car as favorite. Returns the new favorite state.
  static bool toggleFavorite(String carId) {
    final u = authNotifier.value;
    if (u == null) return false;
    if (u.favoriteCarIds.contains(carId)) {
      u.favoriteCarIds.remove(carId);
    } else {
      u.favoriteCarIds.add(carId);
    }
    authNotifier.notifyListeners();
    return u.favoriteCarIds.contains(carId);
  }

  static bool isFavorite(String carId) =>
      authNotifier.value?.favoriteCarIds.contains(carId) ?? false;
}
