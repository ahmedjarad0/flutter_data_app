import 'package:database/models/product.dart';
import 'package:database/models/response_process.dart';
import 'package:database/provider/product_provider.dart';
import 'package:database/utils/extension.dart';
import 'package:database/utils/helper.dart';
import 'package:database/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../pref/shared_pref.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, this.product}) : super(key: key);
  final Product? product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with Helpers {
  late TextEditingController _nameEditingController;
  late TextEditingController _infoEditingController;
  late TextEditingController _priceEditingController;
  late TextEditingController _quantityEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameEditingController = TextEditingController(text: widget.product?.name);
    _infoEditingController = TextEditingController(text: widget.product?.info);
    _priceEditingController =
        TextEditingController(text: widget.product?.price.toString());
    _quantityEditingController =
        TextEditingController(text: widget.product?.quantity.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameEditingController.dispose();
    _infoEditingController.dispose();
    _priceEditingController.dispose();
    _quantityEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),
            AppTextField(
                textInputType: TextInputType.text,
                hintText: context.localization.name,
                prefixIcon: Icons.title,
                controller: _nameEditingController),
            SizedBox(
              height: 15.h,
            ),
            AppTextField(
                textInputType: TextInputType.text,
                hintText: context.localization.info,
                prefixIcon: Icons.info,
                controller: _infoEditingController),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: context.localization.price,
                    prefixIcon: Icons.monetization_on,
                    controller: _priceEditingController,
                    textInputType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppTextField(
                      textInputType: const TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      hintText: context.localization.quantity,
                      prefixIcon: Icons.numbers,
                      controller: _quantityEditingController),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              onPressed: () async {
                _performSave();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(context.localization.save),
            )
          ],
        ),
      ),
    );
  }

  bool get isUpdatedProduct => widget.product != null;

  String get title => isUpdatedProduct
      ? context.localization.product_update
      : context.localization.product_create;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_nameEditingController.text.isNotEmpty &&
        _infoEditingController.text.isNotEmpty &&
        _priceEditingController.text.isNotEmpty &&
        _quantityEditingController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(message: context.localization.error_data, error: true);
    return false;
  }

  Future<void> _save() async {
    //TODO : call Database with ProductProvider InterMediate UI & Controller
    ProcessResponses processResponses = isUpdatedProduct
        ? await Provider.of<ProductProvider>(context, listen: false)
            .update(product)
        : await Provider.of<ProductProvider>(context, listen: false)
            .create(product);

    showSnackBar(context,
        message: processResponses.message, error: !processResponses.success);
    if (processResponses.success) {
      isUpdatedProduct ? Navigator.pop(context) : clear();
    }
  }

  Product get product {
    Product product = isUpdatedProduct ? widget.product! : Product();
    product.name = _nameEditingController.text;
    product.info = _infoEditingController.text;
    product.price = double.parse(_priceEditingController.text);
    product.quantity = int.parse(_quantityEditingController.text);
    product.userId = SharedPerfController().getValue<int>(PerfKeys.id.name)!;
    return product;
  }

  void clear() {
    _nameEditingController.clear();
    _infoEditingController.clear();
    _priceEditingController.clear();
    _quantityEditingController.clear();
  }
}
