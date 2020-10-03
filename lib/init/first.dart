import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class OOBE extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<OOBE> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter'),
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.gift_fill,
                      size: 75,
                      color: Colors.redAccent,
                    ),
                    Container(
                      child: Text(''),
                    ),
                    Container(
                      child: Text(''),
                    ),
                    Center(
                      child: Text(
                        'Bun venit la Askaris!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(''),
                    ),
                    Container(
                      child: Text(''),
                    ),
                    Container(
                      child: Text(''),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(15),
                            child: Text(
                              'Să începem!',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () => {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => Authentication()))
                                }),
                      ),
                    ),
                    Container(
                      child: Text(''),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
