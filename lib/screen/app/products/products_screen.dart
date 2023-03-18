import 'package:database/models/cart.dart';
import 'package:database/models/product.dart';
import 'package:database/models/response_process.dart';
import 'package:database/pref/shared_pref.dart';
import 'package:database/provider/cart_provider.dart';
import 'package:database/provider/product_provider.dart';
import 'package:database/screen/app/products/product_screen.dart';
import 'package:database/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).read();
    Provider.of<ProductProvider>(context, listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.products),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/product_screen');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductScreen()));
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                _confirmLogoutDialog();
                // Navigator.pushReplacementNamed(context, '/login_screen');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          if (value.products.isNotEmpty) {
            return ListView.builder(
              itemCount: value.products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.shop)),
                  title: Text(value.products[index].name),
                  subtitle: Text(value.products[index].info),
                  trailing: Column(
                    children: [
                      Expanded(
                        child: IconButton(
                            iconSize: 22,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .create(getCart(value.products[index]));
                            },
                            icon: const Icon(Icons.add_shopping_cart)),
                      ),
                      Expanded(
                        child: IconButton(
                            iconSize: 22,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            onPressed: () {
                              _deletedProduct(index);
                            },
                            icon: const Icon(Icons.delete)),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductScreen(product: value.products[index])));
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'NO Data',
                style: TextStyle(fontSize: 22),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cart_screen');
          },
          child: Icon(Icons.shopping_cart_rounded)),
    );
  }

  void _confirmLogoutDialog() async {
    bool? result = await showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.logout_alter_sure,
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.black),
            ),
            content: Text(
              AppLocalizations.of(context)!.logout_alter,
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.black54),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: GoogleFonts.cairo(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: GoogleFonts.cairo(),
                  ))
            ],
          );
        });
    if (result ?? false) {
      bool remove =
          await SharedPerfController().removeValueFor(PerfKeys.loggedIn.name);
      // bool clean = await SharedPerfController().clean();
      if (remove) {
        Navigator.pushReplacementNamed(context, '/login_screen');
        // print(remove);
      }
    }
  }

  Cart getCart(Product product) {
    Cart cart = Cart();
    cart.productId = product.id;
    cart.count = 1;
    cart.price = product.price;
    cart.total = product.price * 1;
    cart.productName = product.name ;
    cart.userId = SharedPerfController().getValue<int>(PerfKeys.id.name)!;
    return cart;
  }

  void _deletedProduct(int index) async {
    ProcessResponses processResponses =
        await Provider.of<ProductProvider>(context, listen: false)
            .delete(index);
    context.showSnackBar(
        message: processResponses.message, error: !processResponses.success);
  }
}
