import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  const FullscreenImageViewer({super.key, required this.photos, this.initialIndex = 0});
  @override State<FullscreenImageViewer> createState() => _FullscreenState();
}
class _FullscreenState extends State<FullscreenImageViewer> {
  late PageController _pageCtrl;
  late int _current;

  @override void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }
  @override void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        PageView.builder(
          controller: _pageCtrl,
          onPageChanged: (i) => setState(() => _current = i),
          itemCount: widget.photos.length,
          itemBuilder: (_, i) => _ZoomPhoto(url: widget.photos[i]),
        ),
        Positioned(top: 0, left: 0, right: 0,
          child: SafeArea(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Text('${_current + 1} / ${widget.photos.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
              IconButton(icon: const Icon(Icons.share, color: Colors.white, size: 22), onPressed: () {}),
            ])))),
        if (widget.photos.length > 1)
          Positioned(bottom: 30, left: 0, right: 0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photos.length > 10 ? 10 : widget.photos.length, (i) =>
                AnimatedContainer(duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _current == i ? 18 : 6, height: 6,
                  decoration: BoxDecoration(
                    color: _current == i ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3)))))),
        if (widget.photos.length > 1 && _current > 0)
          Positioned(left: 8, top: 0, bottom: 0, child: Center(child: GestureDetector(
            onTap: () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
            child: Container(padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18))))),
        if (widget.photos.length > 1 && _current < widget.photos.length - 1)
          Positioned(right: 8, top: 0, bottom: 0, child: Center(child: GestureDetector(
            onTap: () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
            child: Container(padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18))))),
      ]),
    );
  }
}

class _ZoomPhoto extends StatefulWidget {
  final String url;
  const _ZoomPhoto({required this.url});
  @override State<_ZoomPhoto> createState() => _ZoomPhotoState();
}
class _ZoomPhotoState extends State<_ZoomPhoto> with SingleTickerProviderStateMixin {
  final _ctrl = TransformationController();
  late AnimationController _animCtrl;
  Animation<Matrix4>? _anim;
  TapDownDetails? _tapDetails;
  bool _zoomed = false;

  @override void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _animCtrl.addListener(() { if (_anim != null) _ctrl.value = _anim!.value; });
  }
  @override void dispose() { _ctrl.dispose(); _animCtrl.dispose(); super.dispose(); }

  void _doubleTap() {
    final Matrix4 end;
    if (_zoomed) {
      end = Matrix4.identity();
    } else {
      final pos = _tapDetails?.localPosition ?? const Offset(100, 100);
      end = Matrix4.identity()
        ..translate(-pos.dx * 1.8, -pos.dy * 1.8)
        ..scale(2.8);
    }
    _anim = Matrix4Tween(begin: _ctrl.value, end: end)
      .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
    _animCtrl.forward(from: 0);
    setState(() => _zoomed = !_zoomed);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onDoubleTapDown: (d) => _tapDetails = d,
    onDoubleTap: _doubleTap,
    child: InteractiveViewer(
      transformationController: _ctrl,
      minScale: 0.8, maxScale: 5.0,
      onInteractionEnd: (_) {
        if (_ctrl.value == Matrix4.identity()) setState(() => _zoomed = false);
      },
      child: Center(child: Image.network(widget.url, fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) => progress == null ? child
          : Center(child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null,
              color: Colors.white)),
        errorBuilder: (_, __, ___) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.directions_car_filled_rounded, color: Colors.white24, size: 80),
          const SizedBox(height: 8),
          const Text('Photo unavailable', style: TextStyle(color: Colors.white38, fontSize: 13)),
        ])))));
}
