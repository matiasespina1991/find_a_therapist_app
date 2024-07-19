import 'dart:developer';

import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/state_utils.dart';

import 'package:flutter/material.dart';

import '../../models/general_models.dart';

class LocationSelectionModal extends StatefulWidget {
  final String type;
  final UserRequestFilters therapistFilters;
  final TextEditingController stateProvinceInputController;
  final TextEditingController cityInputController;

  const LocationSelectionModal({
    super.key,
    required this.type,
    required this.therapistFilters,
    required this.stateProvinceInputController,
    required this.cityInputController,
  });

  @override
  _LocationSelectionModalState createState() => _LocationSelectionModalState();
}

class _LocationSelectionModalState extends State<LocationSelectionModal> {
  late TextEditingController searchController;
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.type == 'state') {
      items = await _getStates(widget.therapistFilters.location.country);
    } else if (widget.type == 'city') {
      items = await _getCities(widget.therapistFilters.location.country,
          widget.therapistFilters.location.state!);
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText:
                    'Search ${widget.type == 'state' ? 'State' : 'City'}',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _filterItems(value),
            ),
          ),
          if (filteredItems.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () {
                      setState(() {
                        if (widget.type == 'state') {
                          widget.therapistFilters.location.state = item.isoCode;
                          widget.stateProvinceInputController.text = item.name;
                          widget.therapistFilters.location.city = null;
                          widget.cityInputController
                              .clear(); // Limpiar el controlador de la ciudad
                        } else if (widget.type == 'city') {
                          widget.therapistFilters.location.city = item.name;
                          widget.cityInputController.text = item
                              .name; // Actualizar el controlador de la ciudad
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
