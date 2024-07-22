#!/bin/bash

# Nombres de los archivos Dart que querés concatenar
files=(
    "pubspec.yaml"
    "lib/app_settings/app_general_settings.dart"
    "lib/app_settings/app_info.dart"
    "lib/app_settings/auth_config.dart"
#    "lib/app_settings/language_settings.dart"
#    "lib/app_settings/theme_settings.dart"
#    "lib/theme/main_theme/main_theme.dart"
#    "lib/routes/routes.dart"a
     "lib/main.dart"
    "lib/providers/providers_all.dart"
    "lib/providers/auth_provider.dart"
#    "lib/providers/theme_provider.dart"
    "lib/widgets/AppScaffold/app_scaffold.dart"
#    "lib/widgets/TherapistListCard/therapist_list_card.dart"
#    "lib/screens/common/login_screen/login_screen.dart"
     "lib/models/therapist_model.dart"
#        "lib/models/term_index_model.dart"
#    "lib/screens/admin/debug_screen/debug_screen.dart"
    "lib/screens/user_area/user_request_screen/user_request_screen.dart"
#    "lib/screens/common/welcome_main_screen/welcome_main_screen.dart"
    "lib/screens/therapist_area/therapist_personal_profile_screen/therapist_personal_profile_screen.dart"

#    "lib/screens/common/all_therapists_screen/all_therapists_screen.dart"
#    "lib/utils/admin/find_best_therapist_by_aspects.dart"
#    "lib/services/gemini_service.dart"
#    "lib/models/gemini_tags_response_model.dart"

    #    "lib/models/current_user_data.dart"
    #    "lib/widgets/NotificationSnackbar/notification_snackbar.dart"
    #    "lib/widgets/NotificationModal/notification_modal.dart"
    #    "lib/providers/locale_provider.dart"
)

# Archivo de salida
output_file="_combined.txt"

# Limpiar el archivo de salida si ya existe
> $output_file

# Ejecutar tree y redirigir la salida al archivo de salida
tree -L 4 -I "android|ios|test|build" >> $output_file

# Concatenar los archivos
for file in "${files[@]}"
do
    echo "///// $file /////" >> $output_file
    cat "$file" >> $output_file
    echo "" >> $output_file # Agregar una línea en blanco entre archivos
done

echo "Files concatenated into $output_file"
