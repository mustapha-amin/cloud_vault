import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration defaultInputDecoration() => InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintStyle: GoogleFonts.montserrat(
        color: Colors.grey[300],
      ),      
    );
