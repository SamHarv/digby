import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkMode = StateProvider<bool>((ref) => true);
final infiniteMode = StateProvider<bool>((ref) => false);
