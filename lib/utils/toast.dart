import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

toastMessage(BuildContext context, String message) {
  // final double width = MediaQuery.of(context).size.width;
  late DelightToastBar? toastBar;
  toastBar = DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    builder: (context) => SizedBox(
      // margin:
      //     EdgeInsets.symmetric(horizontal: width > webscreensize ? 200 : width),
      width: 400,
      child: ToastCard(
        trailing: IconButton(
            onPressed: () => toastBar?.remove(),
            icon: const Icon(Icons.cancel_outlined)),
        leading: const Icon(
          Icons.flutter_dash,
          size: 28,
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
  toastBar.show(context);
}
