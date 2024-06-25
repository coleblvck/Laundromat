
import 'package:laundromat/state/interface_state.dart';
import 'package:laundromat/state/sort_state.dart';
import 'package:laundromat/state/state.dart';

initApp() async {
  interfaceState = InterfaceState();
  sortState = SortState();
  await sortState.initState();
}
