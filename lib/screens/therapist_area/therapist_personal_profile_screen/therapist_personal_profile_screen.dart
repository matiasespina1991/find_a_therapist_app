import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../routes/routes.dart';

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

  // Controladores para los campos de texto
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _publicPresentationController = TextEditingController();
  TextEditingController _privateNotesController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateProvinceController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _profilePictureUrlController = TextEditingController();
  List<String> _specializations = [];
  List<String> _spokenLanguages = [];
  bool _presential = false;
  bool _remote = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backButton: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.welcomeMainScreen.path);
        }
      },
      hideFloatingSpeedDialMenu: true,
      scrollPhysics: NeverScrollableScrollPhysics(),
      appBarTitle: "Therapist Profile",
      useTopAppBar: true,
      actions: [
        /// settings button
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            context.push(Routes.settingsScreen.path);
          },
        ),
      ],
      isProtected: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(
                      'lib/assets/placeholders/default_profile_picture.jpg'),
                ),
                Positioned(
                  right: -4,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.black26,
                        width: 3,
                      )),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 19,
                        ),
                        color: Colors.black54,
                        onPressed: () {
                          // Acción del ícono de cámara
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              dividerColor: Colors.transparent,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Personal Info'),
                Tab(text: 'About me'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Personal Info Tab
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text('Full name'),
                          TextFormField(
                            controller: _fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Birthday'),
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
                          const SizedBox(height: 16),
                          const Text('E-mail'),
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
                          SizedBox(height: 16),
                          Text('Phone'),
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
                          const SizedBox(height: 16),
                          const Text('Address'),
                          TextFormField(
                            controller: _addressController,
                          ),
                          const SizedBox(height: 16),
                          const Text('City'),
                          TextFormField(
                            controller: _cityController,
                          ),
                          const SizedBox(height: 16),
                          const Text('Country'),
                          TextFormField(
                            controller: _countryController,
                          ),
                          const SizedBox(height: 16),
                          const Text('State/Province'),
                          TextFormField(
                            controller: _stateProvinceController,
                          ),
                          SizedBox(height: 16),
                          Text('ZIP Code'),
                          TextFormField(
                            controller: _zipController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Profile Picture URL'),
                          TextFormField(
                            controller: _profilePictureUrlController,
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _specializations
                                .map((specialization) => Chip(
                                      label: Text(specialization),
                                      onDeleted: () {
                                        setState(() {
                                          _specializations
                                              .remove(specialization);
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                          const Text('Add Specialization'),
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
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _spokenLanguages
                                .map((language) => Chip(
                                      label: Text(language),
                                      onDeleted: () {
                                        setState(() {
                                          _spokenLanguages.remove(language);
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                          Text('Add Spoken Language'),
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
                          SizedBox(height: 16),
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
                              Text('Presential'),
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
                              Text('Remote'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // About me Tab
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text('Bio'),
                        TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your bio';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Text('Public Presentation'),
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
                        SizedBox(height: 16),
                        Text('Private Notes'),
                        TextFormField(
                          controller: _privateNotesController,
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Acción del botón de guardar cambios
                  }
                },
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
