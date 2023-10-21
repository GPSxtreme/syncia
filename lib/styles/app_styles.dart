import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncia/controllers/theme_controller.dart';

Widget kDevLogo = Obx(() => Text(
      "GPS",
      style: GoogleFonts.fugazOne(
          color: ThemeController.to.isDarkTheme.value
              ? Colors.white12
              : Colors.black12,
          fontSize: 20),
    ));
