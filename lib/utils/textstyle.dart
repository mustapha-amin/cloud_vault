import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/theme_provider.dart';

TextStyle kTextStyle({
  required BuildContext context,
  required double size,
  Color? color,
  FontWeight? fontWeight,
}) {
  var provider = Provider.of<ThemeProvider>(context);
  return GoogleFonts.montserrat(
    color: color ?? (provider.isDark ? Colors.white : Colors.black),
    fontSize: size.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    
  );
}
