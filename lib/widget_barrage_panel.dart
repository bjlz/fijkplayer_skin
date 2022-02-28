import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BarragePanel extends StatefulWidget {
  final double width;
  final double height;
  final String text;
  final Color color;

  BarragePanel({
    required this.width,
    required this.height,
    required this.text,
    this.color = Colors.transparent,
  });

  @override
  State<StatefulWidget> createState() => _BiuBiuPanelState();
}

class _BiuBiuPanelState extends State<BarragePanel> {
  final _random = Random();
  final _items = <Widget>[];

  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fire();
      _timer = Timer.periodic(
        Duration(seconds: 16),
        (timer) {
          _fire();
        },
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fire() {
    _items.add(_buildBiuBiu());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.color,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: _items,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBiuBiu() {
    // -1 ~ 1
    final yAlign = _random.nextDouble() * 2 - 1;
    return Align(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      alignment: Alignment(0, yAlign),
      child: SizedBox(
        width: widget.width,
        child: _Item(text: widget.text, onCompleted: _onCompleted),
      ),
    );
  }

  void _onCompleted() {
    _items.removeAt(0);
  }
}

class _Item extends StatefulWidget {
  final String text;
  final Function() onCompleted;

  const _Item({
    Key? key,
    required this.text,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<_Item> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 32),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted();
        }
      });

    _animation = Tween(
      begin: Offset(-1.0, 0),
      end: Offset(1.0, 0),
    ).animate(_controller);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 10,
          color: Color(0x1effffff),
          shadows: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 1.1,
            ),
          ],
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
