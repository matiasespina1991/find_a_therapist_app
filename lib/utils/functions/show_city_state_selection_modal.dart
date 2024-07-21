import 'package:findatherapistapp/models/general_models.dart';
import 'package:flutter/material.dart';

import '../../widgets/LocationSelectionModal/location_selection_modal.dart';

void showCityStateSelectionModal(BuildContext context,
    {required String type,
    required String country,
    String? state,
    required Function(dynamic) onSelect}) {
  showModalBottomSheet(
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return LocationSelectionModal(
        type: type,
        state: state,
        country: country,
        onSelect: (selectedItem) => onSelect(selectedItem),
      );
    },
  );
}
