// import 'package:doggobox/index.dart';
// import 'package:doggobox/routing/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case EmailRoute:
//       return _getPageRoute(SqueezePageMobile(), settings);
//     case PurchaseRoute:
//       return _getPageRoute(CreditCardPage(), settings);
//     // case OneTimeOfferRoute:
//     //   return _getPageRoute(OneTimeOfferRoute(), settings);
//     // case UpSellRoute:
//     //   return _getPageRoute(UpSellRoute(), settings);
//     default:
//       return _getPageRoute(SqueezePageMobile(), settings);
//   }
// }

// PageRoute _getPageRoute(Widget child, RouteSettings settings) {
//   return _FadeRoute(child: child, routeName: settings.name);
// }

// class _FadeRoute extends PageRouteBuilder {
//   final Widget child;
//   final String routeName;
//   _FadeRoute({this.child, this.routeName})
//       : super(
//           settings: RouteSettings(name: routeName),
//           pageBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) =>
//               child,
//           transitionsBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child,
//           ) =>
//               FadeTransition(
//             opacity: animation,
//             child: child,
//           ),
//         );
// }
