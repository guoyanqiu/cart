// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/common/theme.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';
import 'package:provider_shopper/screens/cart.dart';
import 'package:provider_shopper/screens/catalog.dart';
import 'package:provider_shopper/screens/login.dart';

import 'screens/nestedtest.dart';
void main() {
  runApp(MyApp());
}


// void main() {
//   runApp(
//     Nested(
//       children: [
//         AWidget(color: Colors.red,width: 400,height: 400),
//         BWidget(color: Colors.blue,width: 300,height: 300),
//         CWidget(color: Colors.green,width: 200,height: 200),
//         DWidget(color: Colors.yellow,width: 100,height: 100),
//       ],
//       // child: const Center(child: Text('Hello flutter', textDirection: TextDirection.ltr),),
//     ),
//   );
// }
// class AWidget extends SingleChildStatelessWidget {
//   const AWidget({Key? key,
//     required this.color,
//     required this.width
//     ,required this.height,
//     Widget? child})
//       : super(key: key, child: child);
//
//   final Color color;
//   final int width,height;
//   @override
//   Widget buildWithChild(BuildContext context, Widget? child) {
//     return Center(child:Container(
//       width: width.toDouble(),
//       height: height.toDouble(),
//       color: color,
//       child: child,
//     ));
//   }
// }
//
// class BWidget extends SingleChildStatelessWidget {
//   const BWidget({Key? key,
//     required this.color,
//     required this.width
//     ,required this.height,
//     Widget? child})
//       : super(key: key, child: child);
//
//   final Color color;
//   final int width,height;
//   @override
//   Widget buildWithChild(BuildContext context, Widget? child) {
//     print("child==="+child.toString());
//     return Center(child:Container(
//       width: width.toDouble(),
//       height: height.toDouble(),
//       color: color,
//       child: child,
//     ));
//   }
// }
//
// class CWidget extends SingleChildStatelessWidget {
//   const CWidget({Key? key,
//     required this.color,
//     required this.width
//     ,required this.height,
//     Widget? child})
//       : super(key: key, child: child);
//
//   final Color color;
//   final int width,height;
//   @override
//   Widget buildWithChild(BuildContext context, Widget? child) {
//     return Center(child:Container(
//       width: width.toDouble(),
//       height: height.toDouble(),
//       color: color,
//       child: child,
//     ));
//   }
// }

// class DWidget extends SingleChildStatelessWidget {
//   const DWidget({Key? key,
//     required this.color,
//     required this.width
//     ,required this.height,
//     Widget? child})
//       : super(key: key, child: child);
//
//   final Color color;
//   final int width,height;
//   @override
//   Widget buildWithChild(BuildContext context, Widget? child) {
//     return Center(child:Container(
//       width: width.toDouble(),
//       height: height.toDouble(),
//       color: color,
//       child: child,
//     ));
//   }
// }
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: new Center(child: NumberWidget()));
  }
}

class NumberWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NumberState();
  }
}

class NumberState extends State<NumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Provider.of<DataModel>(context,listen: false).count.toString(),
            style: TextStyle(color: Colors.blue, fontSize: 48)),
        RaisedButton(
          child: Text("+1"),
          onPressed: () {
            setState(() {
              Provider.of<DataModel>(context,listen: false).count++;
            });
          },
        ),
        RaisedButton(
            child: Text("下一页"),
            onPressed: () {
              Navigator.pushNamed(context, '/page2');
            })
      ],
    );
  }
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DataModel(count: 1),

      child: MaterialApp(
        title: 'ShareDataWidget',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/page2': (context) => Page3(),
        },
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text('ProviderPage', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child:Center(
            child:Consumer<DataModel>(
                     builder: (context, dataModel, child) =>
                         Text(dataModel.count.toString(),
                             style: TextStyle(color: Colors.red, fontSize: 48)),
             )
        // ),
      )),
    );
  }
}

class DataModel {
  int count;
  DataModel({
    required this.count,
  });
  int get getCount => count;
  void setCount(int value) {
    count = value;
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('ProviderPage', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Text(Provider.of<DataModel>(context,listen: false).count.toString(),
              style: TextStyle(color: Colors.red, fontSize: 48)),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyCatalog(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
//
// class ShareDataWidget extends InheritedWidget {
//   ShareDataWidget({
//     Key? key,
//     required this.count,
//     required Widget child,
//   }) : super(key: key, child: child);
//
//   int count;
//
//   static ShareDataWidget of(BuildContext context) {
//     final ShareDataWidget? result =
//         context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
//     assert(result != null, 'No ShareDataWidget found in context');
//     return result!;
//   }
//
//   @override
//   bool updateShouldNotify(ShareDataWidget old) {
//     return old.count != count;
//   }
// }
//
// class MyApp2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Using MultiProvider is convenient when providing multiple objects.
//     return ShareDataWidget(
//       count: 1,
//       child: MaterialApp(
//         title: 'ShareDataWidget',
//         theme: appTheme,
//         initialRoute: '/',
//         routes: {
//           '/': (context) => HomePage(),
//           '/page2': (context) => Page2(),
//
//           ///第二页，用来显示最新的count值
//         },
//       ),
//     );
//   }
// }
//
