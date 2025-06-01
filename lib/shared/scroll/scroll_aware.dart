// import 'package:flutter/material.dart';

// typedef ScrollControllerWidgetBuilder = Widget Function(ScrollController controller);

// class ScrollControllerAwareBuilder extends StatelessWidget {
//   final ScrollControllerWidgetBuilder builder;

//   const ScrollControllerAwareBuilder({super.key, required this.builder});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.findAncestorStateOfType<_MainLayoutState>();
//     if (state == null) {
//       throw Exception('Must be used inside MainLayout');
//     }
//     return builder(state._scrollController);
//   }
// }
