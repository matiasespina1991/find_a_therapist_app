// lib/screens/therapist_area/therapist_personal_profile_screen.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/providers/providers_all.dart';
import 'package:findatherapistapp/providers/therapist_provider.dart';
import 'package:findatherapistapp/routes/routes.dart';
import 'package:findatherapistapp/services/profile_service.dart';

import '../../../utils/functions/profile_utils.dart';

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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _publicPresentationController =
      TextEditingController();
  final TextEditingController _privateNotesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateProvinceController =
      TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _profilePictureUrlController =
      TextEditingController();
  List<String> _specializations = [];
  List<String> _spokenLanguages = [];
  bool _presential = false;
  bool _remote = false;
  File? _selectedImage;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    therapistId = null;
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _publicPresentationController.dispose();
    _privateNotesController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _stateProvinceController.dispose();
    _zipController.dispose();
    _profilePictureUrlController.dispose();
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
      final downloadUrl =
          await uploadProfilePicture(_selectedImage!, 'therapist');

      if (downloadUrl != null) {
        setState(() {
          _profilePictureUrlController.text = downloadUrl;
        });

        // Aquí puedes actualizar el perfil del terapeuta con la URL de la imagen subida
        debugPrint('Image uploaded: $downloadUrl');
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final imageFile = await pickImage(ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        _selectedImage = imageFile;
      });
      final downloadUrl =
          await uploadProfilePicture(_selectedImage!, 'therapist');

      if (downloadUrl != null) {
        setState(() {
          _profilePictureUrlController.text = downloadUrl;
        });

        debugPrint('Image uploaded: $downloadUrl');
      }
    }
  }

  Future<void> _saveChanges() async {
    final profileService = ref.read(profileServiceProvider);

    // Obtener el documento actual del terapeuta
    final currentDoc = await FirestoreService.instance
        .collection('therapists')
        .doc(therapistId)
        .get();
    final currentData = currentDoc.data() as Map<String, dynamic>;

    final Map<String, dynamic> updatedData = {
      'therapistInfo': {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'birthday': _birthdayController.text,
        'email': _emailController.text,
        'phone': {
          'number': _phoneController.text,
          'areaCode':
              '', // Asegúrate de manejar el código de área si es necesario
        },
        'intro': _bioController.text,
        'publicPresentation': _publicPresentationController.text,
        'privateNotes': _privateNotesController.text,
        'location': {
          'address': _addressController.text,
          'city': _cityController.text,
          'country': _countryController.text,
          'stateProvince': _stateProvinceController.text,
          'zip': _zipController.text,
          'geolocation': GeoPoint(0.0,
              0.0) // Asegúrate de manejar la geolocalización si es necesario
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
        'title': '', // Asegúrate de manejar el título si es necesario
        'userInfoIsVerified':
            false, // Asegúrate de manejar la verificación si es necesario
        'professionalCertificates':
            currentData['therapistInfo']['professionalCertificates'] ?? [],
      }
    };

    try {
      await profileService.updateProfile(
        profileTarget: 'therapist',
        userId: therapistId!,
        data: updatedData,
        profilePicture: _selectedImage,
      );
      // Mostrar un mensaje de éxito o hacer alguna acción adicional
      debugPrint('Profile updated successfully');

      ref.read(therapistProvider.notifier).fetchTherapist(therapistId!);
    } catch (e) {
      // Manejar el error
      debugPrint('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    final therapistState = ref.watch(therapistProvider);
    final therapist = therapistState.therapist;

    if (therapist == null) {
      return const Center(child: CircularProgressIndicator());
    }

    print('firstName: ${therapist.therapistInfo.firstName}');
    print('lastName: ${therapist.therapistInfo.lastName}');

    therapistId = therapist.id;

    // Solo actualizar los controladores si están vacíos para evitar sobrescribir los cambios locales
    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = therapist.therapistInfo.firstName;
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameController.text = therapist.therapistInfo.lastName;
    }
    if (_bioController.text.isEmpty) {
      _bioController.text = therapist.therapistInfo.intro;
    }
    if (_publicPresentationController.text.isEmpty) {
      _publicPresentationController.text =
          therapist.therapistInfo.publicPresentation;
    }
    if (_privateNotesController.text.isEmpty) {
      _privateNotesController.text = therapist.therapistInfo.privateNotes;
    }
    if (_addressController.text.isEmpty) {
      _addressController.text = therapist.therapistInfo.location.address;
    }
    if (_cityController.text.isEmpty) {
      _cityController.text = therapist.therapistInfo.location.city;
    }
    if (_countryController.text.isEmpty) {
      _countryController.text = therapist.therapistInfo.location.country;
    }
    if (_stateProvinceController.text.isEmpty) {
      _stateProvinceController.text =
          therapist.therapistInfo.location.stateProvince;
    }
    if (_zipController.text.isEmpty) {
      _zipController.text = therapist.therapistInfo.location.zip;
    }
    if (_profilePictureUrlController.text.isEmpty) {
      _profilePictureUrlController.text =
          therapist.therapistInfo.profilePictureUrl.large;
    }
    _presential = therapist.therapistInfo.meetingType.presential;
    _remote = therapist.therapistInfo.meetingType.remote;
    _specializations = therapist.therapistInfo.specializations;
    _spokenLanguages = therapist.therapistInfo.spokenLanguages;
    final labelTextStyle = Theme.of(context).textTheme.titleMedium;

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
      appBarTitle: "Your Therapist Profile",
      centerTitle: true,
      useTopAppBar: true,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
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
                      return FlexibleSpaceBar(
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
                                              color:
                                                  Colors.grey.withOpacity(0.1),
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
                                            shape: BoxShape.circle,
                                            image: therapist
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
                                                    image: NetworkImage(
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
                                          onPressed:
                                              _pickImageFromCamera, // Llamar a la nueva función aquí
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
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
                            const SizedBox(height: 16),
                            Text(
                              'First Name',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Last Name',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Birthday',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _birthdayController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () {
                                // Acción para seleccionar la fecha
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your birthday';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Email',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Phone',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Address',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _addressController,
                            ),
                            const SizedBox(height: 10),
                            Text('City', style: labelTextStyle),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cityController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Country',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _countryController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'State/Province',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _stateProvinceController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Zip Code',
                              style: labelTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _zipController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Add Specialization/s',
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
                              'Add Spoken Language/s',
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
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _presential,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _presential = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'Presential',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _remote,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _remote = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'Remote',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
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
                          SizedBox(height: 16),
                          Text(
                            'Intro',
                            style: labelTextStyle,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _bioController,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your intro';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Public Presentation',
                            style: labelTextStyle,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _publicPresentationController,
                            maxLines: 8,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your public presentation';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Private Notes',
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
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
