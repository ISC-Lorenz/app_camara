import 'package:app_camara/firebase_options.dart';
import 'package:app_camara/camera_test/providers/products_provider.dart';
import 'package:app_camara/camera_test/screens/add_product_screen.dart';
import 'package:app_camara/camera_test/screens/home_screen.dart';
import 'package:app_camara/camera_test/screens/product_editing.screen.dart';
import 'package:app_camara/camera_test/screens/shopping_cart.dart';
import 'package:app_camara/practica_bloc/bloc/account_bloc.dart';
import 'package:app_camara/practica_bloc/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyBlocApp());
  runApp(const MyBlocApp());
}

class MyBlocApp extends StatelessWidget {
  const MyBlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(),
      child: MaterialApp(
        title: 'Demo BLOC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        ),
        routes: {'/': (context) => const HomeScreenBloc()},
        initialRoute: '/',
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
      ],
      child: MaterialApp(
        title: 'Demo camera',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/product-info': (context) => ProductInfoScreen(),
          '/add-product': (context) => AddProductScreen(),
          '/view-shopping-cart': (context) => ShoppingCartScreen(),
        },
        initialRoute: '/',
        // home: const HomePage(),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
