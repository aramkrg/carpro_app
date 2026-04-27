import '../models/reel.dart';

// ── Sample cars ───────────────────────────────────────────────────
final kCars = <Map<String,dynamic>>[
  {'id':'1','name':'Toyota Camry 2021',  'price':21500.0,    'cur':'USD','city':'Erbil',       'km':32000,'brand':'Toyota',  'year':2021,'fuel':'Petrol', 'trans':'Automatic','fav':false,'vip':true, 'cat':'used','cond':'clean'},
  {'id':'2','name':'BMW 530i 2020',      'price':28900.0,    'cur':'USD','city':'Sulaymaniyah','km':55000,'brand':'BMW',    'year':2020,'fuel':'Petrol', 'trans':'Automatic','fav':false,'vip':false,'cat':'used','cond':'painted'},
  {'id':'3','name':'Hyundai Elantra',    'price':16800.0,    'cur':'USD','city':'Duhok',       'km':44000,'brand':'Hyundai','year':2020,'fuel':'Petrol', 'trans':'Automatic','fav':true, 'vip':false,'cat':'used','cond':'clean'},
  {'id':'4','name':'Kia Sportage 2027',  'price':31500.0,    'cur':'USD','city':'Baghdad',     'km':0,    'brand':'Kia',    'year':2027,'fuel':'Hybrid', 'trans':'Automatic','fav':false,'vip':true, 'cat':'new', 'cond':'new'},
  {'id':'5','name':'Mercedes C200',      'price':38000.0,    'cur':'USD','city':'Erbil',       'km':28000,'brand':'Mercedes','year':2021,'fuel':'Petrol','trans':'Automatic','fav':false,'vip':false,'cat':'used','cond':'clean'},
  {'id':'6','name':'Lexus LX600 2023',   'price':125000000.0,'cur':'IQD','city':'Baghdad',     'km':8000, 'brand':'Lexus',  'year':2023,'fuel':'Petrol', 'trans':'Automatic','fav':true, 'vip':true, 'cat':'used','cond':'clean'},
];

// ── Sample reels — each ties back to a car in kCars ───────────────
final List<Reel> kReels = [
  Reel(id: 'r1', sellerId: 's1', sellerName: 'Erbil Auto', sellerVerified: true,
    carId: '1', brand: 'Toyota', model: 'Camry', trim: 'XSE',
    price: 21500, currency: 'USD', year: 2021,
    viewCount: 12400, likeCount: 832),
  Reel(id: 'r2', sellerId: 's2', sellerName: 'Premium Motors', sellerVerified: true,
    carId: '2', brand: 'BMW', model: '530i', trim: 'M Sport',
    price: 28900, currency: 'USD', year: 2020,
    viewCount: 8900, likeCount: 654),
  Reel(id: 'r3', sellerId: 's3', sellerName: 'Hawler Cars',
    carId: '4', brand: 'Kia', model: 'Sportage', trim: 'GT-Line',
    price: 31500, currency: 'USD', year: 2027,
    viewCount: 24100, likeCount: 1543, isLiked: true),
  Reel(id: 'r4', sellerId: 's4', sellerName: 'Sulaymaniyah Auto', sellerVerified: true,
    carId: '5', brand: 'Mercedes', model: 'C200', trim: 'AMG Line',
    price: 38000, currency: 'USD', year: 2021,
    viewCount: 18700, likeCount: 1102),
  Reel(id: 'r5', sellerId: 's5', sellerName: 'Lexus Iraq',
    carId: '6', brand: 'Lexus', model: 'LX600', trim: 'Ultra Luxury',
    price: 125000000, currency: 'IQD', year: 2023,
    viewCount: 45200, likeCount: 3211, isLiked: true, isFollowingSeller: true),
  Reel(id: 'r6', sellerId: 's6', sellerName: 'Duhok Wheels',
    carId: '3', brand: 'Hyundai', model: 'Elantra', trim: 'Limited',
    price: 16800, currency: 'USD', year: 2020,
    viewCount: 5400, likeCount: 234),
];
