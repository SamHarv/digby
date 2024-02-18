import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final isDarkMode = StateProvider<bool>((ref) => true);
final isInfiniteMode = StateProvider<bool>((ref) => false);
final goblinMotionState = StateProvider<bool>((ref) => true);

final gameFont = GoogleFonts.pressStart2p(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: "PressStart2P",
  ),
);
