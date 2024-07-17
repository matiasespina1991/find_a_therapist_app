import 'package:flutter/cupertino.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

class GooglePlaceAutocompleteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? country;

  const GooglePlaceAutocompleteTextField({
    super.key,
    this.country,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlacesAutoCompleteTextFormField(
        countries: country != null ? [country!] : null,
        maxLines: 1,
        predictionsStyle: const TextStyle(fontSize: 16),
        textEditingController: controller,
        googleAPIKey: "AIzaSyBxk7_Ie3GXQGueETkWkSMenc2Yw9spiy8",
        debounceTime: 400,
        itmClick: (prediction) {
          controller.text = prediction.description ?? '';
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        });
  }
}
