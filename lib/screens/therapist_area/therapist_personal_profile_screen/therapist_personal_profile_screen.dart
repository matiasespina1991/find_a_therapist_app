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
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
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
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
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
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(
                        'lib/assets/placeholders/default_profile_picture.jpg'),
                  ),
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
                        icon: const Icon(
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
              tabAlignment: TabAlignment.center,
              dividerColor: Colors.transparent,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Personal Info',
                ),
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
                          Text(
                            'First Name',
                            style: Theme.of(context).textTheme.titleMedium,
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
                          SizedBox(height: 10),
                          Text(
                            'Last Name',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'City',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _cityController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Country',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _countryController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'State/Province',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _stateProvinceController,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Zip Code',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _zipController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Add Specialization/s',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
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
                              Text(
                                'Presential',
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
                                    _remote = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remote',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
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
                        Text(
                          'Bio',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
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
                        const SizedBox(height: 10),
                        Text(
                          'Public Presentation',
                          style: Theme.of(context).textTheme.titleMedium,
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
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
