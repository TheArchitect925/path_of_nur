getting a exception when going to the full page quran player ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY
╞═══════════════════════════════════════════════════════════
The following StateNotifierListenerError was thrown building Builder:
At least listener of the StateNotifier Instance of 'StateController<bool>' threw
an exception
when the notifier tried to update its state.

The exceptions thrown are:

Tried to modify a provider while the widget tree was building.
If you are encountering this error, chances are you tried to modify a provider
in a widget life-cycle, such as but not limited to:
- build
- initState
- dispose
- didUpdateWidget
- didChangeDependencies

Modifying a provider inside those life-cycles is not allowed, as it could
lead to an inconsistent UI state. For example, two widgets could listen to the
same provider, but incorrectly receive different states.


To fix this problem, you have one of two solutions:
- (preferred) Move the logic for modifying your provider outside of a widget
  life-cycle. For example, maybe you could update your provider inside a
  button's
  onPressed instead.

- Delay your modification, such as by encapsulating the modification
  in a `Future(() {...})`.
  This will perform your update after the widget tree is done building.
#0      _UncontrolledProviderScopeElement._debugCanModifyProviders
(package:flutter_riverpod/src/framework.dart:349:7)
#1      ProviderElementBase._notifyListeners.<anonymous closure>
(package:riverpod/src/framework/element.dart:488:34)
#2      ProviderElementBase._notifyListeners
(package:riverpod/src/framework/element.dart:490:8)
#3      ProviderElementBase.setState
(package:riverpod/src/framework/element.dart:140:7)
#4      StateProviderElement.create.<anonymous closure>
(package:riverpod/src/state_provider/base.dart:149:9)
#5      StateNotifier.state= (package:state_notifier/state_notifier.dart:227:31)
#6      StateController.state=
(package:riverpod/src/state_controller.dart:15:31)
#7      _QuranFocusRecitationPageState.initState
(package:path_of_nur/features/learn/quran/presentation/quran_focus_recitation_page.dart:50:57)
