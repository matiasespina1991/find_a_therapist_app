#!/bin/bash

# Nombres de los archivos Dart que querés concatenar
files=(
     "pubspec.yaml"
    "lib/app_settings/app_general_settings.dart"
    "lib/app_settings/app_info.dart"
    "lib/app_settings/auth_config.dart"
    "lib/app_settings/language_settings.dart"
    "lib/app_settings/theme_settings.dart"
    "lib/theme/main_theme/main_theme.dart"
    "lib/routes/routes.dart"
     "lib/main.dart"
    "lib/providers/providers_all.dart"
    "lib/providers/auth_provider.dart"
    "lib/providers/theme_provider.dart"
    "lib/widgets/AppScaffold/app_scaffold.dart"
    "lib/screens/common/home_screen/home_screen.dart"
    "lib/screens/common/login_screen/login_screen.dart"
    "lib/screens/admin/debug_screen/debug_screen.dart"
    "lib/screens/user_area/user_request_screen/user_request_screen.dart"
    "lib/services/gemini_service.dart"
#    "lib/widgets/NotificationSnackbar/notification_snackbar.dart"
#    "lib/widgets/NotificationModal/notification_modal.dart"
#    "lib/providers/locale_provider.dart"
    "lib/models/current_user_data.dart"
    "lib/models/gemini_tags_response_model.dart"
    "pubspec.yaml"
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
