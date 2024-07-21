import 'dart:developer';

import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/state_utils.dart';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../generated/l10n.dart';
import '../../models/general_models.dart';
import '../ModalTopChip/modal_top_chip.dart';

class LocationSelectionModal extends StatefulWidget {
  final String type;
  // final UserRequestFilters? therapistFilters;
  final String country;
  final String? state;
  final Function(dynamic) onSelect;

  const LocationSelectionModal({
    super.key,
    required this.type,
    required this.country,
    this.state,
    required this.onSelect,
  });

  @override
  _LocationSelectionModalState createState() => _LocationSelectionModalState();
}

class _LocationSelectionModalState extends State<LocationSelectionModal> {
  late TextEditingController searchController;
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool fetchFinished = false;

  @override
  void initState() {
    super.initState();

    if (widget.type == 'city' && widget.state == null) {
      debugPrint('ERROR: You must provide a state when type is city.');
    }
    searchController = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (widget.type == 'state') {
      items = await _getStates(widget.country);

      setState(() {
        fetchFinished = true;
      });
    } else if (widget.type == 'city') {
      items = await _getCities(widget.country, widget.state!);

      setState(() {
        fetchFinished = true;
      });
    }
    setState(() {
      filteredItems = items;
    });
  }

  void _filterItems(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = items;
    } else {
      results = items
          .where((item) =>
              item.name.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredItems = results;
    });
  }

  Future<List<Object>> _getStates(String countryCode) async {
    try {
      return await getStatesOfCountry(countryCode);
    } catch (e) {
      log('Error fetching states: $e');
      return [];
    }
  }

  Future<List<City>> _getCities(String countryCode, String stateCode) async {
    try {
      return await getStateCities(countryCode, stateCode);
    } catch (e) {
      log('Error fetching cities: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalTopChip(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText:
                    '${S.of(context).searchPrefix}${widget.type == 'state' ? S.of(context).stateProvince.toLowerCase() : S.of(context).city.toLowerCase()}',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _filterItems(value),
            ),
          ),
          if (fetchFinished && filteredItems.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 250,
                  height: 650,
                  child: Center(
                    child: Text(
                        S.of(context).noResultsAvailableForSelectedCountryState,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0)),
                  ),
                ),
              ),
            ),
          if (filteredItems.isEmpty && !fetchFinished)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final item = 'example city of the  $index';
                    return Skeletonizer(
                      child: ListTile(
                        title: Text(item),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(item.name),
                      onTap: () {
                        widget.onSelect(
                            item); // Llamar a onSelect con el elemento seleccionado
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
