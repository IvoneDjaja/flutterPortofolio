import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/layout/adaptive.dart';
import 'package:portofolio/src/studies/drawing/routes.dart' as drawing_routes;
import 'package:portofolio/src/studies/rally/routes.dart' as rally_routes;

const _horizontalPadding = 32.0;
const _horizontalDesktopPadding = 81.0;
const _carouselHeightMin = 240.0;
const _carouselItemDesktopMargin = 8.0;
const _carouselItemMobileMargin = 4.0;
const _carouselItemWidth = 296.0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final carouselCards = <Widget>[
      const _CarouselCard(
        studyRoute: drawing_routes.homeRoute,
      ),
      const _CarouselCard(
        studyRoute: rally_routes.homeRoute,
      )
    ];
    return Scaffold(
      body: ListView(
        key: const ValueKey('HomeListView'),
        children: [
          _DesktopCarousel(
            height: _carouselHeightMin,
            children: carouselCards,
          ),
        ],
      ),
    );
  }
}

/// This creates a horizontally scrolling [ListView] of items.
///
/// This class uses a [ListView] with a custom [ScrollPhysics] to enable
/// snapping behavior. A [PageView] was considered but does not allow for
/// multiple pages visible without centering the first page.
class _DesktopCarousel extends StatefulWidget {
  const _DesktopCarousel({
    required this.height,
    required this.children,
  });

  final double height;
  final List<Widget> children;

  @override
  State<_DesktopCarousel> createState() => __DesktopCarouselState();
}

class __DesktopCarouselState extends State<_DesktopCarousel> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var showPreviousButton = false;
    var showNextButton = true;

    // Only check this after the _controller has been attached to the ListView.
    if (_controller.hasClients) {
      showPreviousButton = _controller.offset > 0;
      showNextButton =
          _controller.offset < _controller.position.maxScrollExtent;
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: widget.height,
        constraints: const BoxConstraints(maxWidth: maxHomeItemWidth),
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: kIsWeb
                    ? _horizontalDesktopPadding - _carouselItemDesktopMargin
                    : _horizontalPadding - _carouselItemMobileMargin,
              ),
              scrollDirection: Axis.horizontal,
              primary:
                  false, // Set as false because we are passing a controller,
              controller: _controller,
              itemExtent: _carouselItemWidth,
              itemCount: widget.children.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: widget.children[index],
              ),
            ),
            if (showPreviousButton)
              _DesktopPageButton(
                onTap: () {
                  _controller.animateTo(
                    _controller.offset - _carouselItemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            if (showNextButton)
              _DesktopPageButton(
                isEnd: true,
                onTap: () {
                  _controller.animateTo(
                    _controller.offset + _carouselItemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DesktopPageButton extends StatelessWidget {
  const _DesktopPageButton({
    this.isEnd = false,
    this.onTap,
  });

  final bool isEnd;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const buttonSize = 58.0;
    const padding = _horizontalDesktopPadding - buttonSize / 2;
    return Container(
      width: buttonSize,
      height: buttonSize,
      margin: EdgeInsetsDirectional.only(
        start: isEnd ? 0 : padding,
        end: isEnd ? padding : 0,
      ),
      child: Material(
          color: Colors.black.withOpacity(0.5),
          shape: const CircleBorder(),
          child: InkWell(
              onTap: onTap,
              child: Icon(
                isEnd ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
              ))),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    super.key,
    required this.studyRoute,
  });

  final String studyRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal:
              kIsWeb ? _carouselItemDesktopMargin : _carouselItemMobileMargin,
        ),
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        height: _carouselHeightMin,
        width: _carouselItemWidth,
        child: Material(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Title'),
                    Text('Subtitle'),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == '/');
                      Navigator.of(context).restorablePushNamed(studyRoute);
                    },
                  ),
                ),
              )
            ])));
  }
}
