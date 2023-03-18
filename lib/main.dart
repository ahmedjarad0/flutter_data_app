import 'package:database/pref/shared_pref.dart';
import 'package:database/provider/cart_provider.dart';
import 'package:database/provider/language_provider.dart';
import 'package:database/provider/product_provider.dart';
import 'package:database/screen/app/products/cart_screen.dart';
import 'package:database/screen/app/products/product_screen.dart';
import 'package:database/screen/app/products/products_screen.dart';
import 'package:database/screen/auth/login_screen.dart';
import 'package:database/screen/auth/register_screen.dart';
import 'package:database/screen/core/launch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'database/db_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPerfController().initShared();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiProvider(providers: [
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),),
          ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider(),),
          ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider(),)
        ]
          , builder: (context, widget) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              locale: Locale(Provider
                  .of<LanguageProvider>(context)
                  .language),
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    iconTheme: const IconThemeData(color: Colors.black),
                    titleTextStyle: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              initialRoute: '/launch_screen',
              routes: {
                '/launch_screen': (context) => const LaunchScreen(),
                '/login_screen': (context) => const LoginScreen(),
                '/register_screen': (context) => const RegisterScreen(),
                '/products_screen': (context) => const ProductsScreen(),
                // '/product_screen': (context) => const ProductScreen(),
                '/cart_screen': (context) => const CartScreen(),


              },
            );
          },);
      },
    );
  }


}