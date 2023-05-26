import 'package:flutter/material.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpansionTileCard Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'ExpansionTileCard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: cardA,
              leading: CircleAvatar(child: Text('A')),
              title: Text('Tap me!'),
              subtitle: Text('I expand!'),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """Hi there, I'm a drop-in replacement for Flutter's ExpansionTile.

Use me any time you think your app could benefit from being just a bit more Material.

These buttons control the next card down!""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.expand();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.arrow_downward),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Open'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.collapse();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.toggleExpansion();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.swap_vert),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Toggle'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              key: cardB,
              expandedTextColor: Colors.red,
              leading: CircleAvatar(child: Text('B')),
              title: Text('Tap me!'),
              subtitle: Text('I expand, too!'),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """Hi there, I'm a drop-in replacement for Flutter's ExpansionTile.

Use me any time you think your app could benefit from being just a bit more Material.

These buttons control the card above!""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardA.currentState?.expand();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.arrow_downward),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Open'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardA.currentState?.collapse();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardA.currentState?.toggleExpansion();
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.swap_vert),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Toggle'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpansionTileCard extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const ExpansionTileCard({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.elevation = 2.0,
    this.initialElevation = 0.0,
    this.initiallyExpanded = false,
    this.initialPadding = EdgeInsets.zero,
    this.finalPadding = const EdgeInsets.only(bottom: 6.0),
    this.contentPadding,
    this.baseColor,
    this.expandedColor,
    this.expandedTextColor,
    this.duration = const Duration(milliseconds: 200),
    this.elevationCurve = Curves.easeOut,
    this.heightFactorCurve = Curves.easeIn,
    this.turnsCurve = Curves.easeIn,
    this.colorCurve = Curves.easeIn,
    this.paddingCurve = Curves.easeIn,
    this.isThreeLine = false,
    this.shadowColor = const Color(0xffaaaaaa),
    this.animateTrailing = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final bool isThreeLine;

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Whether or not to animate a custom trailing widget.
  ///
  /// Defaults to false.
  final bool animateTrailing;

  /// The radius used for the Material widget's border. Only visible once expanded.
  ///
  /// Defaults to a circular border with a radius of 8.0.
  final BorderRadiusGeometry borderRadius;

  /// The final elevation of the Material widget, once expanded.
  ///
  /// Defaults to 2.0.
  final double elevation;

  /// The elevation when collapsed
  ///
  /// Defaults to 0.0
  final double initialElevation;

  /// The color of the cards shadow.
  ///
  /// Defaults to Color(0xffaaaaaa)
  final Color shadowColor;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// The padding around the outside of the ExpansionTileCard while collapsed.
  ///
  /// Defaults to EdgeInsets.zero.
  final EdgeInsetsGeometry initialPadding;

  /// The padding around the outside of the ExpansionTileCard while collapsed.
  ///
  /// Defaults to 6.0 vertical padding.
  final EdgeInsetsGeometry finalPadding;

  /// The inner `contentPadding` of the ListTile widget.
  ///
  /// If null, ListTile defaults to 16.0 horizontal padding.
  final EdgeInsetsGeometry contentPadding;

  /// The background color of the unexpanded tile.
  ///
  /// If null, defaults to Theme.of(context).canvasColor.
  final Color baseColor;

  /// The background color of the expanded card.
  ///
  /// If null, defaults to Theme.of(context).cardColor.
  final Color expandedColor;

  ///The color of the text of the expended card
  ///
  ///If null, defaults to Theme.of(context).accentColor.
  final Color expandedTextColor;

  /// The duration of the expand and collapse animations.
  ///
  /// Defaults to 200 milliseconds.
  final Duration duration;

  /// The animation curve used to control the elevation of the expanded card.
  ///
  /// Defaults to Curves.easeOut.
  final Curve elevationCurve;

  /// The animation curve used to control the height of the expanding/collapsing card.
  ///
  /// Defaults to Curves.easeIn.
  final Curve heightFactorCurve;

  /// The animation curve used to control the rotation of the `trailing` widget.
  ///
  /// Defaults to Curves.easeIn.
  final Curve turnsCurve;

  /// The animation curve used to control the header, icon, and material colors.
  ///
  /// Defaults to Curves.easeIn.
  final Curve colorCurve;

  /// The animation curve used by the expanding/collapsing padding.
  ///
  /// Defaults to Curves.easeIn.
  final Curve paddingCurve;

  @override
  ExpansionTileCardState createState() => ExpansionTileCardState();
}

class ExpansionTileCardState extends State<ExpansionTileCard>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _materialColorTween = ColorTween();
  EdgeInsetsTween _edgeInsetsTween;
  Animatable<double> _elevationTween;
  Animatable<double> _heightFactorTween;
  Animatable<double> _turnsTween;
  Animatable<double> _colorTween;
  Animatable<double> _paddingTween;

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<double> _elevation;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _materialColor;
  Animation<EdgeInsets> _padding;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _edgeInsetsTween = EdgeInsetsTween(
      begin: widget.initialPadding as EdgeInsets,
      end: widget.finalPadding as EdgeInsets,
    );
    _elevationTween = CurveTween(curve: widget.elevationCurve);
    _heightFactorTween = CurveTween(curve: widget.heightFactorCurve);
    _colorTween = CurveTween(curve: widget.colorCurve);
    _turnsTween = CurveTween(curve: widget.turnsCurve);
    _paddingTween = CurveTween(curve: widget.paddingCurve);

    _controller = AnimationController(duration: widget.duration, vsync: this);
    _heightFactor = _controller.drive(_heightFactorTween);
    _iconTurns = _controller.drive(_halfTween.chain(_turnsTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_colorTween));
    _materialColor = _controller.drive(_materialColorTween.chain(_colorTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_colorTween));
    _elevation = _controller.drive(
        Tween<double>(begin: widget.initialElevation, end: widget.elevation)
            .chain(_elevationTween));
    _padding = _controller.drive(_edgeInsetsTween.chain(_paddingTween));
    _isExpanded = PageStorage.of(context)?.readState(context) as bool ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Credit: Simon Lightfoot - https://stackoverflow.com/a/48935106/955974
  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null)
        widget.onExpansionChanged(_isExpanded);
    }
  }

  void expand() {
    _setExpansion(true);
  }

  void collapse() {
    _setExpansion(false);
  }

  void toggleExpansion() {
    _setExpansion(!_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Padding(
      padding: _padding.value,
      child: Material(
        type: MaterialType.card,
        color: _materialColor.value,
        borderRadius: widget.borderRadius,
        elevation: _elevation.value,
        shadowColor: widget.shadowColor,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                customBorder:
                    RoundedRectangleBorder(borderRadius: widget.borderRadius),
                onTap: toggleExpansion,
                child: ListTileTheme.merge(
                  iconColor: _iconColor.value,
                  textColor: _headerColor.value,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      isThreeLine: widget.isThreeLine,
                      contentPadding: widget.contentPadding,
                      leading: widget.leading,
                      title: widget.title,
                      subtitle: widget.subtitle,
                      trailing: RotationTransition(
                        turns: widget.trailing == null || widget.animateTrailing
                            ? _iconTurns
                            : AlwaysStoppedAnimation(0),
                        child: widget.trailing ?? Icon(Icons.expand_more),
                      ),
                    ),
                  ),
                ),
              ),
              ClipRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
     ThemeData theme = Theme.of(context);
    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = widget.expandedTextColor ?? theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = widget.expandedTextColor ?? theme.accentColor;
    _materialColorTween
      ..begin = widget.baseColor ?? theme.canvasColor
      ..end = widget.expandedColor ?? theme.cardColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
