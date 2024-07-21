import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/models/state.dart' as state_utils;
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:findatherapistapp/widgets/NotificationModal/notification_modal.dart';
import 'package:findatherapistapp/widgets/NotificationSnackbar/notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/providers/providers_all.dart';
import 'package:findatherapistapp/providers/therapist_provider.dart';
import 'package:findatherapistapp/routes/routes.dart';
import 'package:findatherapistapp/services/profile_service.dart';
import 'package:country_picker/country_picker.dart';
import '../../../generated/l10n.dart';
import '../../../utils/functions/profile_utils.dart';
import '../../../utils/functions/show_city_state_selection_modal.dart';
import '../../../utils/ui/get_dash_flag_by_country_code.dart';

class TherapistPersonalProfileScreen extends ConsumerStatefulWidget {
  const TherapistPersonalProfileScreen({super.key});

  @override
  ConsumerState<TherapistPersonalProfileScreen> createState() =>
      _TherapistPersonalProfileScreenState();
}

class _TherapistPersonalProfileScreenState
    extends ConsumerState<TherapistPersonalProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late String? therapistId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phoneAreaCodeController =
      TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final TextEditingController _publicPresentationController =
      TextEditingController();
  final TextEditingController _privateNotesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _stateProvinceCodeController =
      TextEditingController();
  final TextEditingController countryNameController = TextEditingController();
  final TextEditingController stateProvinceNameController =
      TextEditingController();
  final TextEditingController cityNameController = TextEditingController();

  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _profilePictureUrlController =
      TextEditingController();
  List<String> _specializations = [];
  List<String> _spokenLanguages = [];
  bool _presential = false;
  bool _remote = false;
  File? _selectedImage;
  bool uploadingProfilePicture = false;
  bool savingChanges = false;

  Timestamp therapistDateOfBirth = Timestamp.fromDate(DateTime(1990, 1, 1));
  GeoPoint therapistGeolocation = const GeoPoint(0, 0);

  late TabController _tabController;
  String? defaultCountry;

  @override
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    stateProvinceNameController.text = '';
  }

  @override
  void dispose() {
    therapistId = null;
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _introController.dispose();
    _publicPresentationController.dispose();
    _privateNotesController.dispose();
    _addressController.dispose();
    _cityCodeController.dispose();
    _countryCodeController.dispose();
    _stateProvinceCodeController.dispose();
    cityNameController.dispose();
    stateProvinceNameController.dispose();
    countryNameController.dispose();
    _zipController.dispose();
    _profilePictureUrlController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final imageFile = await pickImage(
      ImageSource.gallery,
    );

    if (imageFile != null) {
      setState(() {
        _selectedImage = imageFile;
      });

      if (mounted) {
        NotificationSnackbar.showSnackBar(
            message: S.of(context).imageUploadedSuccessfully,
            variant: 'success',
            duration: 'short');
      }

      final downloadUrl =
          await uploadProfilePicture(_selectedImage!, 'therapist');

      if (downloadUrl != null) {
        setState(() {
          _profilePictureUrlController.text = downloadUrl;
        });

        debugPrint('Image uploaded successfully');
      } else {
        debugPrint('Error uploading image');
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final imageFile = await pickImage(ImageSource.camera,
        preferredCamera: CameraDevice.front);

    if (imageFile != null) {
      setState(() {
        _selectedImage = imageFile;
      });

      debugPrint('Image uploaded successfully');
      final downloadUrl =
          await uploadProfilePicture(_selectedImage!, 'therapist');

      if (downloadUrl != null) {
        setState(() {
          _profilePictureUrlController.text = downloadUrl;
        });

        NotificationSnackbar.showSnackBar(
            message: S.of(context).imageUploadedSuccessfully,
            variant: 'success',
            duration: 'short');
      }
    }
  }

  Future<void> _saveChanges() async {
    bool isDarkMode = ref.watch(themeProvider).themeMode == ThemeMode.dark;
    setState(() {
      savingChanges = true;
    });
    final profileService = ref.read(profileServiceProvider);

    final currentDoc = await FirestoreService.instance
        .collection('therapists')
        .doc(therapistId)
        .get();
    final currentData = currentDoc.data() as Map<String, dynamic>;

    final Map<String, dynamic> updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'birthday': therapistDateOfBirth,
      'email': _emailController.text,
      'phone': {
        'number': _phoneController.text,
        'areaCode': _phoneAreaCodeController.text,
      },
      'intro': _introController.text,
      'publicPresentation': _publicPresentationController.text,
      'privateNotes': _privateNotesController.text,
      'location': {
        'address': _addressController.text,
        'city': _cityCodeController.text,
        'country': _countryCodeController.text,
        'stateProvince': stateProvinceNameController.text,
        'zip': _zipController.text,
        'geolocation': therapistGeolocation,
      },
      'specializations': _specializations,
      'spokenLanguages': _spokenLanguages,
      'meetingType': {
        'presential': _presential,
        'remote': _remote,
      },
      'profilePictureUrl': {
        'large': _profilePictureUrlController.text,
        'small': '',
        'thumb': ''
      },
      'title': '',
      'userInfoIsVerified': false,
      'professionalCertificates':
          currentData['therapistInfo']['professionalCertificates'] ?? [],
    };

    try {
      bool therapistDataUploadedSuccesfully =
          await profileService.updateProfile(
        profileTarget: 'therapist',
        userId: therapistId!,
        data: {'therapistInfo': updatedData},
        profilePicture: _selectedImage,
      );

      if (therapistDataUploadedSuccesfully) {
        debugPrint('Profile updated successfully');

        ref.read(therapistProvider.notifier).updateTherapistInfo(updatedData);

        if (mounted) {
          NotificationModal.successfulModal(
            context: context,
            title: S.of(context).profileSaved,
            message: S.of(context).profileSavedMessage,
          );
        }
      } else {
        debugPrint('Error updating profile');
        if (mounted) {
          NotificationModal.errorModal(
            icon: isDarkMode ? Icons.error_outline : Icons.error,
            context: context,
            title: S.of(context).errorSavingProfile,
            message: S.of(context).errorSavingProfileMessage,
          );
        }
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }

    setState(() {
      savingChanges = false;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    final therapistState = ref.watch(therapistProvider);
    final therapist = therapistState.therapist;
    final labelTextStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15);

    if (therapist == null) {
      return const Center(child: CircularProgressIndicator());
    }

    therapistId = therapist.id;

    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = therapist.therapistInfo.firstName;
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameController.text = therapist.therapistInfo.lastName;
    }

    if (_emailController.text.isEmpty) {
      _emailController.text = therapist.therapistInfo.email;
    }

    if (_phoneController.text.isEmpty) {
      _phoneController.text = therapist.therapistInfo.phone.number;
    }

    if (_phoneAreaCodeController.text.isEmpty) {
      _phoneAreaCodeController.text = therapist.therapistInfo.phone.areaCode;
    }

    if (_introController.text.isEmpty) {
      _introController.text = therapist.therapistInfo.intro;
    }
    if (_publicPresentationController.text.isEmpty) {
      _publicPresentationController.text =
          therapist.therapistInfo.publicPresentation;
    }
    if (_privateNotesController.text.isEmpty) {
      _privateNotesController.text = therapist.therapistInfo.privateNotes;
    }

    if (_profilePictureUrlController.text.isEmpty) {
      _profilePictureUrlController.text =
          therapist.therapistInfo.profilePictureUrl.large;
    }

    if (_addressController.text.isEmpty) {
      _addressController.text = therapist.therapistInfo.location.address;
    }
    if (_cityCodeController.text.isEmpty) {
      _cityCodeController.text = therapist.therapistInfo.location.city;
    }
    if (_countryCodeController.text.isEmpty) {
      _countryCodeController.text = therapist.therapistInfo.location.country;
      countryNameController.text = CountryLocalizations.of(context)!
          .countryName(countryCode: therapist.therapistInfo.location.country)!;
    }
    if (_stateProvinceCodeController.text.isEmpty) {
      _stateProvinceCodeController.text =
          therapist.therapistInfo.location.stateProvince;
      stateProvinceNameController.text =
          therapist.therapistInfo.location.stateProvince;
    }

    if (therapistGeolocation.latitude == 0 &&
        therapistGeolocation.longitude == 0) {
      therapistGeolocation = therapist.therapistInfo.location.geolocation;
    }
    if (_zipController.text.isEmpty) {
      _zipController.text = therapist.therapistInfo.location.zip;
    }
    _presential = therapist.therapistInfo.meetingType.presential;
    _remote = therapist.therapistInfo.meetingType.remote;
    _specializations = therapist.therapistInfo.specializations;
    _spokenLanguages = therapist.therapistInfo.spokenLanguages;

    return AppScaffold(
      ignoreGlobalPadding: true,
      backButton: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.welcomeMainScreen.path);
        }
      },
      hideFloatingSpeedDialMenu: true,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      appBarTitle: S.of(context).yourTherapistProfile,
      centerTitle: true,
      useTopAppBar: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.push(Routes.settingsScreen.path);
          },
        ),
      ],
      isProtected: false,
      body: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: isDarkMode
                      ? ThemeSettings.scaffoldBackgroundColor.darkModePrimary
                      : ThemeSettings.scaffoldBackgroundColor.lightModePrimary,
                  surfaceTintColor: Color(0xFF4B4B4B),
                  leading: Container(),
                  expandedHeight: 220.0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double top = constraints.biggest.height;
                      return Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ThemeSettings
                                  .scaffoldBackgroundColor.darkModePrimary
                              : ThemeSettings
                                  .scaffoldBackgroundColor.lightModePrimary,
                          boxShadow: [
                            if (innerBoxIsScrolled)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 1.0,
                                offset: Offset(0, 0.8),
                              ),
                          ],
                        ),
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Column(
                            children: [
                              const SizedBox(height: 20),
                              Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.black.withAlpha(30),
                                        onTap: _pickImageFromGallery,
                                        child: AnimatedContainer(
                                          clipBehavior: Clip.hardEdge,
                                          duration: Duration(milliseconds: 100),
                                          margin: EdgeInsets.only(
                                            top: top > 160.0 ? 0.0 : 17.0,
                                          ),
                                          width: top > 160.0 ? 140.0 : 80.0,
                                          height: top > 160.0 ? 140.0 : 80.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 1,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: _selectedImage != null
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                        _selectedImage!.path,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : therapist
                                                          .therapistInfo
                                                          .profilePictureUrl
                                                          .large
                                                          .isEmpty
                                                      ? const DecorationImage(
                                                          image: AssetImage(
                                                            'lib/assets/placeholders/default_profile_picture.jpg',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            therapist
                                                                .therapistInfo
                                                                .profilePictureUrl
                                                                .large,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (top > 160.0)
                                    Positioned(
                                      right: -4,
                                      top: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(0),
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          border:
                                              Border.fromBorderSide(BorderSide(
                                            color: Colors.black26,
                                            width: 3,
                                          )),
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              size: 19,
                                            ),
                                            color: Colors.black54,
                                            onPressed: _pickImageFromCamera,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  bottom: TabBar(
                    overlayColor:
                        WidgetStateProperty.all<Color>(Colors.transparent),
                    splashFactory: null,
                    controller: _tabController,
                    tabAlignment: TabAlignment.center,
                    indicator: BoxDecoration(
                        color: isDarkMode
                            ? ThemeSettings.primaryTextColor.darkModePrimary
                                .withOpacity(0.9)
                            : ThemeSettings.primaryTextColor.lightModePrimary
                                .withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(2),
                          bottomLeft: Radius.circular(2),
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        )),
                    indicatorPadding: const EdgeInsets.only(top: 44),
                    indicatorColor: ThemeSettings.seedColor.withOpacity(0.7),
                    dividerColor: Colors.transparent,
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    labelPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    tabs: const [
                      Tab(
                        text: 'Personal Info',
                      ),
                      Tab(text: 'About me'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Personal Info Tab
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 16.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 16),
                            // Text(
                            //   'Title',
                            //   style: labelTextStyle,
                            // ),
                            // const SizedBox(height: 8),
                            // TextFormField(
                            //   controller: _titleController,
                            // ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).firstName,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterYourFullName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).lastName,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterYourFullName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).email,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterYourEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).phone,
                              style: labelTextStyle,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 80,
                                  ),
                                  child: TextFormField(
                                    controller: _phoneAreaCodeController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: '000',
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 18,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone area code';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      hintText: '000 000 0000',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return S
                                            .of(context)
                                            .pleaseEnterYourPhoneNumber;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Text(
                            //   S.of(context).birthday,
                            //   style: labelTextStyle,
                            // ),
                            // const SizedBox(height: 8),
                            // TextFormField(
                            //   controller: _birthdayController,
                            //   decoration: const InputDecoration(
                            //     suffixIcon: Icon(Icons.calendar_today),
                            //   ),
                            //   readOnly: true,
                            //   onTap: () {
                            //     // Acción para seleccionar la fecha
                            //   },
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return S.of(context).pleaseEnterYourBirthday;
                            //     }
                            //     return null;
                            //   },
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).country,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false,
                                  favorite: defaultCountry != null
                                      ? [defaultCountry!]
                                      : null,
                                  countryListTheme: CountryListThemeData(
                                    bottomSheetHeight:
                                        MediaQuery.of(context).size.height *
                                            0.85,
                                    textStyle: const TextStyle(
                                        height: 2, fontSize: 16.5),
                                  ),
                                  customFlagBuilder: (Country country) {
                                    return getDashFlagByCountryCode(
                                        country.countryCode);
                                  },
                                  onSelect: (Country country) {
                                    setState(() {
                                      if (_countryCodeController.text !=
                                          country.countryCode) {
                                        stateProvinceNameController.text = '';
                                        _stateProvinceCodeController.text = '';
                                        _cityCodeController.text = '';
                                        cityNameController.text = '';

                                        therapist.therapistInfo.location
                                            .stateProvince = '';
                                        therapist.therapistInfo.location.city =
                                            '';
                                      }

                                      _countryCodeController.text =
                                          country.countryCode;
                                      countryNameController.text =
                                          country.nameLocalized!;
                                      defaultCountry = country.countryCode;
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  textAlign: _countryCodeController.text.isEmpty
                                      ? TextAlign.center
                                      : TextAlign.start,
                                  controller: countryNameController,
                                  decoration: InputDecoration(
                                    hintText: '< Select >',
                                    hintStyle: TextStyle(
                                      color: _countryCodeController.text.isEmpty
                                          ? Colors.black
                                          : (isDarkMode
                                              ? ThemeSettings
                                                  .hintTextColor.darkModePrimary
                                              : ThemeSettings.hintTextColor
                                                  .lightModePrimary),
                                    ),
                                    prefixIcon: _countryCodeController
                                            .text.isEmpty
                                        ? null
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 8),
                                            child: getDashFlagByCountryCode(
                                                _countryCodeController.text),
                                          ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minWidth: 41,
                                      minHeight: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).stateProvince,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showCityStateSelectionModal(
                                  context,
                                  type: 'state',
                                  country: _countryCodeController.text,
                                  onSelect: (selectedItem) {
                                    state_utils.State stateProvinceSelected =
                                        selectedItem;

                                    setState(() {
                                      _stateProvinceCodeController.text =
                                          stateProvinceSelected.isoCode;
                                      stateProvinceNameController.text =
                                          stateProvinceSelected.name;
                                      _cityCodeController.clear();

                                      if (stateProvinceSelected.latitude !=
                                              null &&
                                          stateProvinceSelected.longitude !=
                                              null) {
                                        therapistGeolocation = GeoPoint(
                                            double.parse(stateProvinceSelected
                                                .latitude!),
                                            double.parse(stateProvinceSelected
                                                .longitude!));
                                      }
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  textAlign:
                                      _stateProvinceCodeController.text.isEmpty
                                          ? TextAlign.center
                                          : TextAlign.start,
                                  controller: stateProvinceNameController,
                                  decoration: InputDecoration(
                                    filled: _stateProvinceCodeController
                                            .text.isEmpty
                                        ? false
                                        : true,
                                    hintText: _stateProvinceCodeController
                                            .text.isEmpty
                                        ? '< Select >'
                                        : '',
                                    hintStyle: TextStyle(
                                      color: _stateProvinceCodeController
                                              .text.isEmpty
                                          ? Colors.black
                                          : (isDarkMode
                                              ? ThemeSettings
                                                  .hintTextColor.darkModePrimary
                                              : ThemeSettings.hintTextColor
                                                  .lightModePrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).city,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showCityStateSelectionModal(
                                  context,
                                  type: 'city',
                                  country: _countryCodeController.text,
                                  state: _stateProvinceCodeController.text,
                                  onSelect: (selectedItem) {
                                    City citySelected = selectedItem;
                                    setState(() {
                                      _cityCodeController.text =
                                          citySelected.name;

                                      if (citySelected.latitude != null &&
                                          citySelected.longitude != null) {
                                        therapistGeolocation = GeoPoint(
                                            double.parse(
                                                citySelected.latitude!),
                                            double.parse(
                                                citySelected.longitude!));
                                      }
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  textAlign: _cityCodeController.text.isEmpty
                                      ? TextAlign.center
                                      : TextAlign.start,
                                  controller: _cityCodeController,
                                  decoration: InputDecoration(
                                    filled: _cityCodeController.text.isEmpty
                                        ? false
                                        : true,
                                    hintText: _cityCodeController.text.isEmpty
                                        ? '< Select >'
                                        : '',
                                    hintStyle: TextStyle(
                                      color: _cityCodeController.text.isEmpty
                                          ? Colors.black
                                          : (isDarkMode
                                              ? ThemeSettings
                                                  .hintTextColor.darkModePrimary
                                              : ThemeSettings.hintTextColor
                                                  .lightModePrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).address,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText: '123 Main St.',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).zipCode,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _zipController,
                              decoration: const InputDecoration(
                                hintText: '12345',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).addSpecializations,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // Acción para agregar especialización
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).addSpokenLanguages,
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // Acción para agregar idioma hablado
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // About me Tab
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            '${S.of(context).meetingType}:',
                            style: labelTextStyle,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: _presential,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _presential = !_presential;
                                    therapist.therapistInfo.meetingType
                                            .presential =
                                        !therapist.therapistInfo.meetingType
                                            .presential;
                                  });
                                },
                              ),
                              Text(
                                S.of(context).presential,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _remote,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _remote = !_remote;
                                    therapist.therapistInfo.meetingType.remote =
                                        !therapist
                                            .therapistInfo.meetingType.remote;
                                  });
                                },
                              ),
                              Text(
                                S.of(context).remote,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            S.of(context).intro,
                            style: labelTextStyle,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _introController,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseEnterYourIntro;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).publicPresentation,
                            style: labelTextStyle,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _publicPresentationController,
                            maxLines: 8,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S
                                    .of(context)
                                    .pleaseEnterYourPublicPresentation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).privateNotes,
                            style: labelTextStyle,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _privateNotesController,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 1.0,
                  offset: Offset(0, -0.8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: savingChanges ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: savingChanges
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).savingChanges),
                        SizedBox(width: 8),
                        const SizedBox(
                            width: 12,
                            height: 12,
                            child: LoadingCircle(
                              strokeWidth: 2.5,
                            ))
                      ],
                    )
                  : Text(S.of(context).saveChanges),
            ),
          ),
        ],
      ),
    );
  }
}
