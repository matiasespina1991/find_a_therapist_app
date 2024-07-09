# Flutter Template App

Template Flutter project.

# 1. Delete any .git folder and initialize a new git repository if necessary. Keep the .gitignore file.

# 2. Rename the Flutter app from `template_app` to the desired name of your app.

1. **Change Package/Bundle ID:**
   - **Android:** Edit `android/app/src/main/AndroidManifest.xml` and change the `package` attribute.
   - **iOS:** Change `CFBundleDisplayName` and `CFBundleName` in `ios/Runner/Info.plist`. Open the
     project in Xcode and change the `Bundle Identifier` in the `General` tab of the Runner target and
     also in the `Signing & Capabilities` tab.

2. **Update Configuration Files:**
   - Modify `applicationId` in `android/app/build.gradle`.
   - Update Firebase configurations if used (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).

3. **Rename Project Folder:**
   - Rename your project folder to `template_app`.

4. **Update Dart Code References:**
   - Update any Dart code references to the package name.

5. **Update App Name:**
   - Change the name in `pubspec.yaml` under the `name` field.

6. **Rename imports:**
   - Rename the imports in the files using the rename_imports.sh script in the root folder of the project.
      - Run `chmod +x rename-imports.sh` to make the script executable.
      - Run `./rename-imports.sh name_of_your_project` to rename the imports.

7. **Clean and Rebuild the Project:**
   - Run `flutter clean`.
   - Run `flutter pub get`.
   - Rebuild the project for both platforms.

8. **Run a clean install of Pods:**
   - Go to the ios folder and run `pod cache clean --all`, `pod deintegrate` and `pod install`.

9. **Check Platform-Specific Configurations:**
   - **Android:** Review `build.gradle` and `settings.gradle`.
   - **iOS:** Adjust settings in Xcode, including project name, targets, and `Info.plist`.

10. **Update External Service References:**
- Update the app name in external services (Firebase, APIs, etc.) as needed.

### Important Naming Conventions and Restrictions:

1. **Directories**:
   - **Allowed**: Underscores (`_`), hyphens (`-`), letters, and numbers.
   - **Not Allowed**: Spaces, special characters like `@`, `#`, `&`, etc.

2. **Package Name (in `pubspec.yaml`)**:
   - **Allowed**: Only underscores (`_`), lowercase letters, and numbers.
   - **Not Allowed**: Hyphens (`-`), spaces, uppercase letters, special characters.
   - Example: `my_package_name`

3. **Bundle ID (iOS)**:
   - **Allowed**: Dots (`.`), letters, and numbers.
   - **Not Allowed**: Underscores (`_`), hyphens (`-`), spaces, special characters.
   - Example: `com.example.myapp`

4. **Firebase iOS ID**:
   - **Allowed**: Dots (`.`), letters, and numbers.
   - **Not Allowed**: Underscores (`_`), hyphens (`-`), spaces, special characters.
   - Example: `com.example.myapp`

5. **Firebase Android ID**:
   - **Allowed**: Dots (`.`), letters, and numbers.
   - **Not Allowed**: Underscores (`_`), hyphens (`-`), spaces, special characters.
   - Example: `com.example.myapp`

# 3. Add Firebase to the Flutter app (using FlutterFire):

1. **Create a Firebase Project:**
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Click on "Add Project" and follow the setup instructions.

2. **Setup Firebase in the App:**
   - Follow these instructions: https://firebase.google.com/docs/flutter/setup.

# 4. Check the supported locales or add new locales (Optional):

1. **Check Supported Locales:**
   - You can find the supported locales in the `lib/config.dart` file, under supportedLocales List.

2. **Add or Remove Locales:**
   - Add a locale creating a file named `intl_{locale}.arb` in the `lib/l10n` folder.
   - Run `flutter pub run intl_utils:generate` to generate the locale files.
   - Remove a locale by deleting the corresponding `intl_{locale}.arb` file and taking it out of the supportedLocales List.

# 5. Add SHA-1 and SHA-256 keys to Firebase (Optional):
- Use the command `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android` to get the SHA-1 key.
- Paste the SHA-1 key in the Firebase project settings under the Android app.

# 6. Things to take into account for pre-production and should be ready prior to the deployment of the app:
### (Check each completed item with a ✅)

### UI Design:
- **Font Type:** Choose a font for the app and define the custom fonts in the app if necessary. [ ]
- **Color Scheme:** Define a color scheme for the app and use it consistently across the app. [ ]
- **Icon Design:** Select the appropriate icons and icon library for the app. [ ]
- **UI Design:** Implement the UI design for the app screens and components. [ ]
- **Responsive Design:** Ensure the app design is responsive and works well on different screen sizes and orientations. [ ]
- **Animation and Transitions:** Implement smooth animations and transitions to enhance the user experience. [ ]

### App Architecture:
- **Navigation:** Implement navigation between screens and manage the app routes. [ ]
- **State Management:** Choose a state management solution for the app and implement it. [ ]
- **Data Management:** Implement data management for the app using APIs, databases, or local storage. [ ]
- **User Authentication:** Implement user authentication and authorization in the app. [ ]
- **Search Functionality:** Add search functionality to the app for users to find content. [ ]
- **Push Notifications:** Implement push notifications for the app using Firebase Cloud Messaging. [ ]
- **Error Handling:** Implement error handling and logging in the app. [ ]
- **Dependency Injection:** Implement dependency injection to manage dependencies and promote testability. [ ]
- **Modularization:** Structure the app into modules to improve maintainability and scalability. [ ]

### UX Design:
- **User Onboarding:** Create user onboarding screens and flows for the app. [ ]
- **Accessibility:** Ensure the app is accessible to users with disabilities. [ ]
- **Status Indicators:** Add loading indicators, error messages, and other status indicators. [ ]
- **User Profile:** Create user profiles and settings for the app. [ ]
- **Dark Mode:** Implement dark mode support for the app. [ ]
- **Offline Support:** Add offline support for the app using local storage or caching. [ ]
- **Localization:** Add support for multiple languages in the app. [ ]
- **Support:** Provide customer support and respond to user queries. [ ]
- **Feedback:** Collect user feedback and reviews for the app. [ ]

### App Features:
- **App Icon:** Replace the default app icon with a custom one. [ ]
- **Splash Screen:** Customize the splash screen for the app. [ ]
- **App Theme:** Define a custom theme for the app. [ ]

### Testing and Deployment:
- **Testing:** Write unit, widget, and integration tests for the app. [ ]
- **Compliance:** Ensure the app complies with legal and regulatory requirements. [ ]
- **Performance:** Optimize the app for performance and memory usage. [ ]
- **Security:** Secure sensitive data and implement secure communication. [ ]
- **Documentation:** Document the app architecture, code, and setup instructions. [ ]
- **Deployment:** Prepare the app for deployment to app stores. [ ]
- **Maintenance:** Plan for app updates, bug fixes, and feature enhancements. [ ]
- **Marketing:** Promote the app through social media, ads, and other channels. [ ]
- **Monetization:** Implement monetization strategies for the app. [ ]

### Continuous Integration/Continuous Deployment (CI/CD):
- **CI/CD Setup:** Set up a CI/CD pipeline using tools like GitHub Actions, GitLab CI, or Jenkins. [ ]
- **Automated Testing:** Ensure that automated tests run as part of the CI pipeline. [ ]
- **Build Automation:** Automate the build process for both Android and iOS. [ ]
- **Deployment Automation:** Automate the deployment process to app stores. [ ]

### Monitoring and Analytics:
- **Crash Reporting:** Implement crash reporting using tools like Firebase Crashlytics. [ ]
- **Analytics:** Integrate analytics to track user behavior and app performance. [ ]
- **Performance Monitoring:** Set up performance monitoring to keep track of app performance in production. [ ]
- **User Feedback:** Collect and analyze user feedback to make informed improvements. [ ]
