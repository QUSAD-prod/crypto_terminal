import 'package:flutter/material.dart';

class AppUi {
  AppUi({required this.context});
  final BuildContext context;

  void buildSnackBar({required String message, bool errorEnabled = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      padding: errorEnabled
          ? const EdgeInsets.only(
              left: 12.0,
              right: 16.0,
              top: 12.0,
              bottom: 12.0,
            )
          : const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
      content: Row(
        children: [
          Container(
            margin: errorEnabled
                ? const EdgeInsets.only(right: 12.0)
                : const EdgeInsets.all(0.0),
            child: errorEnabled
                ? const Icon(
                    Icons.cancel,
                    color: Color(0xFFE7522E),
                  )
                : const SizedBox(),
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
