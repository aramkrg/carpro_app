import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

class FilterSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>)? onApply;
  // Legacy backward-compatible callback: onChanged(currency, min, max)
  final Function(String, double, double)? onChanged;

  const FilterSheet({
    super.key,
    this.initialFilters = const {},
    this.onApply,
    this.onChanged,
    // Legacy params
    String? currency,
    double? min,
    double? max,
    String? brand,
    String? condition,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _keywordCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Filter state
  String? _selectedBrand;
  String _selectedModel = 'All';
  String _selectedTrim = 'All';
  String _fromYear = 'All';
  String _toYear = 'All';
  String _minPrice = 'All';
  String _maxPrice = 'All';
  String _minMileage = 'All';
  String _maxMileage = 'All';
  String _plateCity = 'All';
  String _plateType = 'All';
  String _condition = 'All';
  String _engineSize = 'All';
  String _cylinder = 'All';
  String _importCountry = 'All';
  String? _selectedColor;
  String _transmission = 'All';
  String _seatMaterial = 'All';
  final List<String> _selectedFuels = [];

  final List<String> _years = ['All', ...List.generate(30, (i) => '${2025 - i}')];
  final List<String> _prices = ['All', '5,000', '10,000', '15,000', '20,000', '30,000', '50,000', '75,000', '100,000', '150,000', '200,000+'];
  final List<String> _mileages = ['All', '10,000', '30,000', '50,000', '75,000', '100,000', '150,000', '200,000+'];
  final List<String> _engineSizes = ['All', '1.0', '1.2', '1.4', '1.5', '1.6', '1.8', '2.0', '2.5', '3.0', '3.5', '4.0', '5.0', '5.7', '6.2'];
  final List<String> _cylinders = ['All', '3', '4', '5', '6', '8', '10', '12'];
  final List<String> _plateCities = ['All', 'Baghdad', 'Erbil', 'Sulaymaniyah', 'Duhok', 'Kirkuk', 'Basra', 'Mosul', 'Najaf', 'Karbala', 'Anbar'];
  final List<String> _plateTypes = ['All', 'Private', 'Commercial', 'Government', 'Diplomatic'];
  final List<String> _importCountries = ['All', 'USA', 'UAE', 'Korea', 'Japan', 'Germany', 'Europe', 'Canada'];
  final List<Map<String, dynamic>> _fuelTypes = [
    {'label': 'Gasoline', 'icon': Icons.local_gas_station},
    {'label': 'Hybrid', 'icon': Icons.electric_bolt},
    {'label': 'EV', 'icon': Icons.ev_station},
    {'label': 'Diesel', 'icon': Icons.oil_barrel},
    {'label': 'LPG', 'icon': Icons.propane},
    {'label': 'CNG', 'icon': Icons.compress},
  ];
  final List<Color> _colors = [
    Colors.white, Colors.black, Colors.grey, Colors.blue, Colors.red,
    Colors.white70, Color(0xFFD4AF37), Colors.green, Color(0xFF8B4513), Colors.orange,
  ];
  final List<String> _seatMaterials = ['All', 'Fabric', 'Leather', 'Mix', 'Alcantara', 'Alcantara/Leather'];

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _keywordCtrl.text = f['keyword'] ?? '';
    _selectedBrand = f['brand'];
    _selectedModel = f['model'] ?? 'All';
    _condition = f['condition'] ?? 'All';
    _transmission = f['transmission'] ?? 'All';
    _seatMaterial = f['seatMaterial'] ?? 'All';
    _fromYear = f['fromYear'] ?? 'All';
    _toYear = f['toYear'] ?? 'All';
    _minPrice = f['minPrice'] ?? 'All';
    _maxPrice = f['maxPrice'] ?? 'All';
    _minMileage = f['minMileage'] ?? 'All';
    _maxMileage = f['maxMileage'] ?? 'All';
    _plateCity = f['plateCity'] ?? 'All';
    _plateType = f['plateType'] ?? 'All';
    _engineSize = f['engineSize'] ?? 'All';
    _cylinder = f['cylinder'] ?? 'All';
    _importCountry = f['importCountry'] ?? 'All';
    _selectedColor = f['color'];
    if (f['fuels'] != null) _selectedFuels.addAll(List<String>.from(f['fuels']));
  }

  @override
  void dispose() {
    _keywordCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _keywordCtrl.clear();
      _selectedBrand = null;
      _selectedModel = 'All';
      _selectedTrim = 'All';
      _fromYear = 'All';
      _toYear = 'All';
      _minPrice = 'All';
      _maxPrice = 'All';
      _minMileage = 'All';
      _maxMileage = 'All';
      _plateCity = 'All';
      _plateType = 'All';
      _condition = 'All';
      _engineSize = 'All';
      _cylinder = 'All';
      _importCountry = 'All';
      _selectedColor = null;
      _transmission = 'All';
      _seatMaterial = 'All';
      _selectedFuels.clear();
    });
  }

  void _apply() {
    String? _n(String v) => v == 'All' ? null : v;
    final filters = <String, dynamic>{
      'keyword': _keywordCtrl.text.trim(),
      'brand': _selectedBrand,
      'model': _n(_selectedModel),
      'trim': _n(_selectedTrim),
      'fromYear': _n(_fromYear),
      'toYear': _n(_toYear),
      'minPrice': _n(_minPrice),
      'maxPrice': _n(_maxPrice),
      'minMileage': _n(_minMileage),
      'maxMileage': _n(_maxMileage),
      'plateCity': _n(_plateCity),
      'plateType': _n(_plateType),
      'condition': _condition,
      'engineSize': _n(_engineSize),
      'cylinder': _n(_cylinder),
      'importCountry': _n(_importCountry),
      'color': _selectedColor,
      'transmission': _transmission,
      'seatMaterial': _seatMaterial,
      'fuels': _selectedFuels,
    };
    widget.onApply?.call(filters);
    // Also call legacy onChanged if provided
    widget.onChanged?.call(
      filters['keyword'] ?? '',
      filters['minPrice'] != null ? (double.tryParse(filters['minPrice'].toString().replaceAll(',', '')) ?? 0.0) : 0.0,
      filters['maxPrice'] != null ? (double.tryParse(filters['maxPrice'].toString().replaceAll(',', '')) ?? 0.0) : 0.0,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Filter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {/* show recent searches */},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── KEYWORD SEARCH ──────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _keywordCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search by keyword, e.g. "Toyota 2020 under 20k"',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: theme.primary),
                        suffixIcon: _keywordCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() => _keywordCtrl.clear()),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── BRANDS ───────────────────────────────────────────────
                  _sectionLabel('Brands'),
                  const SizedBox(height: 10),
                  _BrandGrid(
                    selected: _selectedBrand,
                    onSelect: (b) => setState(() => _selectedBrand = _selectedBrand == b ? null : b),
                  ),
                  const SizedBox(height: 20),

                  // ── MODEL / TRIM ────────────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('Model', _selectedModel, ['All', 'Camry', 'Corolla', 'Land Cruiser', 'Hilux', 'Sportage', 'Tucson', 'Elantra', 'Accent'],
                        (v) => setState(() => _selectedModel = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('Trim', _selectedTrim, ['All', 'GX', 'GLE', 'VX', 'Limited', 'SE', 'XLE', 'Sport', 'Prestige'],
                        (v) => setState(() => _selectedTrim = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 16),

                  // ── YEAR ────────────────────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('From Year', _fromYear, _years, (v) => setState(() => _fromYear = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('To Year', _toYear, _years, (v) => setState(() => _toYear = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 16),

                  // ── PRICE ───────────────────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('Min Price', _minPrice, _prices, (v) => setState(() => _minPrice = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('Max Price', _maxPrice, _prices, (v) => setState(() => _maxPrice = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 16),

                  // ── MILEAGE ─────────────────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('Min Mileage', _minMileage, _mileages, (v) => setState(() => _minMileage = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('Max Mileage', _maxMileage, _mileages, (v) => setState(() => _maxMileage = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 16),

                  // ── PLATE CITY / TYPE ───────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('Plate City', _plateCity, _plateCities, (v) => setState(() => _plateCity = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('Plate Type', _plateType, _plateTypes, (v) => setState(() => _plateType = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 20),

                  // ── CONDITION ───────────────────────────────────────────
                  _sectionLabel('Condition'),
                  const SizedBox(height: 10),
                  _chipRow(['All', 'Used', 'New'], _condition, (v) => setState(() => _condition = v)),
                  const SizedBox(height: 20),

                  // ── ENGINE / CYLINDER ───────────────────────────────────
                  Row(children: [
                    Expanded(child: _dropdownField('Engine Size', _engineSize, _engineSizes, (v) => setState(() => _engineSize = v ?? 'All'))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdownField('Cylinder', _cylinder, _cylinders, (v) => setState(() => _cylinder = v ?? 'All'))),
                  ]),
                  const SizedBox(height: 16),

                  // ── IMPORT COUNTRY ──────────────────────────────────────
                  _sectionLabel('Import Country'),
                  const SizedBox(height: 10),
                  _dropdownField('Import Country', _importCountry, _importCountries, (v) => setState(() => _importCountry = v ?? 'All'), fullWidth: true),
                  const SizedBox(height: 20),

                  // ── COLOR ───────────────────────────────────────────────
                  _sectionLabel('Color'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colors.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        if (i == _colors.length) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          );
                        }
                        final color = _colors[i];
                        final colorHex = '#${color.value.toRadixString(16).substring(2)}';
                        final isSelected = _selectedColor == colorHex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = isSelected ? null : colorHex),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: isSelected ? theme.primary : Colors.grey.shade300,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: isSelected ? Icon(Icons.check, color: color == Colors.white ? Colors.black : Colors.white, size: 18) : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── FUEL TYPE ───────────────────────────────────────────
                  _sectionLabel('Fuel'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _fuelTypes.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        if (i == _fuelTypes.length) {
                          return Container(
                            width: 72,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Icon(Icons.arrow_forward_ios, size: 16)),
                          );
                        }
                        final fuel = _fuelTypes[i];
                        final isSelected = _selectedFuels.contains(fuel['label']);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) _selectedFuels.remove(fuel['label']);
                            else _selectedFuels.add(fuel['label']);
                          }),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? theme.primary.withOpacity(0.1) : Colors.white,
                              border: Border.all(color: isSelected ? theme.primary : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(fuel['icon'], color: isSelected ? theme.primary : Colors.grey.shade600, size: 28),
                                const SizedBox(height: 4),
                                Text(fuel['label'], style: TextStyle(fontSize: 11, color: isSelected ? theme.primary : Colors.grey.shade700)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── TRANSMISSION ────────────────────────────────────────
                  _sectionLabel('Transmission'),
                  const SizedBox(height: 10),
                  _chipRow(['All', 'Automatic', 'Manual'], _transmission, (v) => setState(() => _transmission = v)),
                  const SizedBox(height: 20),

                  // ── SEAT MATERIAL ───────────────────────────────────────
                  _sectionLabel('Seat Material'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _seatMaterials.map((m) {
                      final sel = _seatMaterial == m;
                      return GestureDetector(
                        onTap: () => setState(() => _seatMaterial = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? Colors.black : Colors.white,
                            border: Border.all(color: sel ? Colors.black : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── BOTTOM ACTIONS ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _apply,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Show', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          Icon(Icons.toggle_off, color: Colors.grey, size: 28),
                          SizedBox(width: 8),
                          Text('Cars', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87));

  Widget _dropdownField(String hint, String value, List<String> items, ValueChanged<String?> onChanged, {bool fullWidth = false}) {
    // Ensure value exists in items, fallback to first item
    final safeValue = items.contains(value) ? value : items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        value: safeValue,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _chipRow(List<String> options, String selected, ValueChanged<String> onTap) {
    return Row(
      children: options.map((o) {
        final sel = selected == o;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onTap(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? Colors.black : Colors.white,
                border: Border.all(color: sel ? Colors.black : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(o, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Brand Grid ──────────────────────────────────────────────────────────────
class _BrandGrid extends StatefulWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  const _BrandGrid({required this.selected, required this.onSelect});

  @override
  State<_BrandGrid> createState() => _BrandGridState();
}

class _BrandGridState extends State<_BrandGrid> {
  bool _showAll = false;

  final List<Map<String, dynamic>> _brands = [
    {'name': 'Toyota', 'color': Color(0xFFEB0A1E)},
    {'name': 'Kia', 'color': Color(0xFF05141F)},
    {'name': 'Hyundai', 'color': Color(0xFF002C5F)},
    {'name': 'Mercedes', 'color': Color(0xFF9B9B9B)},
    {'name': 'BMW', 'color': Color(0xFF1C69D4)},
    {'name': 'Nissan', 'color': Color(0xFFC3002F)},
    {'name': 'Lexus', 'color': Color(0xFF1A1A1A)},
    {'name': 'Jeep', 'color': Color(0xFF1A8000)},
    {'name': 'BYD', 'color': Color(0xFF1DB6E6)},
    {'name': 'Jetour', 'color': Color(0xFF000000)},
    {'name': 'Omoda', 'color': Color(0xFF000000)},
    {'name': 'Chery', 'color': Color(0xFFD4002A)},
    {'name': 'MG', 'color': Color(0xFF8B0000)},
    {'name': 'Volkswagen', 'color': Color(0xFF001E50)},
    {'name': 'Haval', 'color': Color(0xFFCC0000)},
    {'name': 'Ford', 'color': Color(0xFF003476)},
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _showAll ? _brands : _brands.take(7).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: visible.length + 1,
      itemBuilder: (_, i) {
        if (i == visible.length) {
          return GestureDetector(
            onTap: () => setState(() => _showAll = !_showAll),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_showAll ? Icons.keyboard_arrow_up : Icons.arrow_forward, size: 20, color: Colors.grey.shade600),
                  Text(_showAll ? 'Less' : 'More', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
          );
        }
        final brand = visible[i];
        final isSelected = widget.selected == brand['name'];
        return GestureDetector(
          onTap: () => widget.onSelect(brand['name']),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? (brand['color'] as Color) : Colors.grey.shade200, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? (brand['color'] as Color).withOpacity(0.08) : Colors.white,
            ),
            child: Center(
              child: Text(
                brand['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? (brand['color'] as Color) : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


// ── FilterPanel ─────────────────────────────────────────────────────────────
// Inline sidebar version of FilterSheet (used in tablet/desktop layouts)
class FilterPanel extends StatefulWidget {
  final String currency;
  final double? min;
  final double? max;
  final Function(String currency, double min, double max)? onChanged;
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic>)? onApply;

  const FilterPanel({
    super.key,
    this.currency = 'USD',
    this.min,
    this.max,
    this.onChanged,
    this.initialFilters,
    this.onApply,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late String _currency;
  late String _minPrice = 'All';
  late String _maxPrice = 'All';
  String _condition = 'All';
  String _transmission = 'All';
  String? _selectedBrand;

  final List<String> _currencies = ['USD', 'IQD'];
  final List<String> _prices = ['All', '5,000', '10,000', '20,000', '30,000', '50,000', '75,000', '100,000', '150,000', '200,000+'];

  @override
  void initState() {
    super.initState();
    _currency = _currencies.contains(widget.currency) ? widget.currency : 'USD';
    _minPrice = 'All';
    _maxPrice = 'All';
  }

  void _notifyChanged() {
    widget.onChanged?.call(
      _currency,
      _minPrice != null ? (double.tryParse(_minPrice!.replaceAll(',', '')) ?? 0.0) : 0.0,
      _maxPrice != null ? (double.tryParse(_maxPrice!.replaceAll(',', '')) ?? 0.0) : 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primary)),
            const SizedBox(height: 16),

            // Currency
            Text('Currency', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                value: _currencies.contains(_currency) ? _currency : _currencies.first,
                items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) { setState(() => _currency = v ?? 'USD'); _notifyChanged(); },
              ),
            ),
            const SizedBox(height: 16),

            // Min Price
            Text('Min Price', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text('All'),
                value: _prices.contains(_minPrice) ? _minPrice : _prices.first,
                items: _prices.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) { setState(() => _minPrice = v ?? 'All'); _notifyChanged(); },
              ),
            ),
            const SizedBox(height: 16),

            // Max Price
            Text('Max Price', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text('All'),
                value: _prices.contains(_maxPrice) ? _maxPrice : _prices.first,
                items: _prices.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) { setState(() => _maxPrice = v ?? 'All'); _notifyChanged(); },
              ),
            ),
            const SizedBox(height: 16),

            // Condition
            Text('Condition', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: ['All', 'Used', 'New'].map((o) {
                final sel = _condition == o;
                return GestureDetector(
                  onTap: () { setState(() => _condition = o); _notifyChanged(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? Colors.black : Colors.white,
                      border: Border.all(color: sel ? Colors.black : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(o, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Transmission
            Text('Transmission', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: ['All', 'Auto', 'Manual'].map((o) {
                final sel = _transmission == o;
                return GestureDetector(
                  onTap: () { setState(() => _transmission = o); _notifyChanged(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? Colors.black : Colors.white,
                      border: Border.all(color: sel ? Colors.black : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(o, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply?.call({
                    'currency': _currency,
                    'minPrice': _minPrice,
                    'maxPrice': _maxPrice,
                    'condition': _condition,
                    'transmission': _transmission,
                  });
                  _notifyChanged();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Apply', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
