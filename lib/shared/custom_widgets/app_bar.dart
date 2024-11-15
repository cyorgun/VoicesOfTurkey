import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../colors/app_colors.dart';
import '../../dimens/dimens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonVisible;
  final Widget? titleWidget;
  final Widget? actionWidget;

  const CustomAppBar(
      {super.key,
      this.isBackButtonVisible = false,
      this.titleWidget,
      this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.iconColor),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          onPressed: () async {
            try {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", true, ScanMode.QR);
            } catch (_) {}
          },
        )
      ],
      leading: isBackButtonVisible
          ? InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.iconColor,
              ),
            )
          : null,
      title: titleWidget ??
          Text(
            "appName".tr,
            style: TextStyle(color: AppColors.textColor),
          ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppColors.buttonGradient),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimens.appBarSize);
}
