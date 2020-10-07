import 'package:doggobox/index.dart';

class AnnouncementBar extends StatelessWidget implements PreferredSizeWidget {
  final bool desktop;
  final String announcement;

  @override
  final Size preferredSize;

  AnnouncementBar({
    this.desktop,
    this.announcement,
    this.preferredSize,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: 35.0,
        color: Theme.of(context).accentColor,
        alignment: Alignment.center,
        child: Text(
          announcement,
          style: TextStyle(
            fontSize: desktop ? 14.0 : 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
