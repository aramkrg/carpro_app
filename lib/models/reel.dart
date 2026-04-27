/// Reel data model. In Phase 1 these come from Firestore.
class Reel {
  final String id, sellerId, sellerName;
  final bool sellerVerified;
  final String carId;
  final String brand, model, trim;
  final double price;
  final String currency;
  final int year;
  final int viewCount, likeCount;
  bool isLiked, isFollowingSeller;

  Reel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    this.sellerVerified = false,
    required this.carId,
    required this.brand,
    required this.model,
    required this.trim,
    required this.price,
    required this.currency,
    required this.year,
    required this.viewCount,
    required this.likeCount,
    this.isLiked = false,
    this.isFollowingSeller = false,
  });
}
