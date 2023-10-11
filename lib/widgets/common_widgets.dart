import 'package:flutter/material.dart';

class CommonWidgets {
  static Future<bool?> commonAlertDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String agreeLabel,
    required String denyLabel,
    bool isSingleBtn = false,
    bool isBarrierDismissible = true,
    Color? agreeButtonColor,
    Color? denyButtonColor,
    Color? titleColor,
    Color? bodyColor,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: isBarrierDismissible,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        actionsPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
              color: titleColor, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        content: Text(
          body,
          style: TextStyle(
              color: bodyColor, fontSize: 14, fontWeight: FontWeight.w400),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.maxFinite,
                    child: Center(
                      child: Text(
                        agreeLabel,
                        style: TextStyle(
                            color: titleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isSingleBtn) ...[
                Divider(
                  color: Colors.grey,
                  indent: 40,
                  endIndent: 40,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.maxFinite,
                      child: Center(
                        child: Text(
                          denyLabel,
                          style: TextStyle(
                              color: titleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }
}
