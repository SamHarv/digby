import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkMode = StateProvider<bool>((ref) => true);
final isInfiniteMode = StateProvider<bool>((ref) => false);
final goblinMotionState = StateProvider<bool>((ref) => true);
