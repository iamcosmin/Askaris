import 'package:flutter/cupertino.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Duration duration = const Duration(milliseconds: 50);
  final double opacity = 0.5;

  TouchableOpacity({@required this.child, this.onTap});

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
      ),
    );
  }
}

class TrailingHelper extends StatefulWidget {
  TrailingHelper({
    @required this.onTap,
    @required this.loader,
  });
  final Function onTap;
  final loader;

  @override
  _TrailingHelperState createState() => _TrailingHelperState();
}

class _TrailingHelperState extends State<TrailingHelper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.loader != true
            ? TouchableOpacity(
                onTap: widget.onTap,
                child: Text('Înainte',
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    )))
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CupertinoActivityIndicator(),
              ),
      ],
    );
  }
}
