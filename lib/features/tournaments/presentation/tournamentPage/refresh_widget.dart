import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    required this.child,
    required this.onRefresh,
  });

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {

  @override
  Widget build(BuildContext context) => Platform.isAndroid ?
    buildAndroidList() : buildIOSList();

  Widget buildAndroidList() => RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: widget.child
  );

  Widget buildIOSList() => CustomScrollView(
    physics: BouncingScrollPhysics(),
    slivers: [
      CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
      SliverToBoxAdapter(child: widget.child)
    ],
  );
}
