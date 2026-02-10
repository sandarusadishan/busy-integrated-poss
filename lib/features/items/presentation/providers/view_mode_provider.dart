import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViewMode { normal, visual }

final viewModeProvider =
    NotifierProvider<ViewModeNotifier, ViewMode>(ViewModeNotifier.new);

class ViewModeNotifier extends Notifier<ViewMode> {
  @override
  ViewMode build() => ViewMode.visual;

  void setMode(ViewMode mode) {
    state = mode;
  }
}
