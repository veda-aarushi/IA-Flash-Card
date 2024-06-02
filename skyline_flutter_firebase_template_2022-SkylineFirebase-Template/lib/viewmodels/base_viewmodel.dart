import 'package:flutter/cupertino.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';

/// Class for view models to extend from. Keeps track
/// of [ViewState] and exposes a function to change the
/// state of the view.

abstract class BaseViewModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  bool _disposed = false;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void setState(ViewState viewState) {
    _state = viewState;

    if (!_disposed) return;

    notifyListeners();
  }

  Future init() async {}

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
