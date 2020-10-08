import 'package:askaris/sdk/askaris_sdk.dart';
import 'package:flutter/cupertino.dart';

class CourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CPS(
      child: Container(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'Setari',
                  textAlign: TextAlign.center,
                ),
              ),
              leading: new Container(),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                return new Future.delayed(const Duration(seconds: 3));
              },
            ),
            SliverSafeArea(
              top: false,
              // This is just a big list of all the items in the settings.
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[Container(), Text("Soon")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
