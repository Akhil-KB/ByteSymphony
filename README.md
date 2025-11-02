# ByteSymphony Flutter Project

## Overview

This project is a Flutter mobile application developed as a machine test for ByteSymphony Business Solutions LLP. It demonstrates a complete, production-level app integrating with live backend APIs via JWT authentication. The focus is on clean UI design, API integration, secure storage, and a smooth user experience.

---

## Features

- **JWT Authentication:** Secure login with token storage.
- **Clients Management:** Search, add, update, and delete clients with paginated results.
- **Invoices Management:** View invoices with filtering options by client and status.
- **Error Handling:** Graceful handling with descriptive error messages.
- **Protected Navigation:** User can't access protected routes without login.
- **Loading States:** Visual feedback with spinners and loading indicators.
- **Confirmation Dialogs:** For critical actions like logout and delete.
- **Responsive UI:** Modern, elegant UI using Material 3 components with gradient accents.
- **Secure Token Storage:** Using Flutter's secure storage package.

---

## Getting Started

### Prerequisites

- Flutter SDK installed (Stable version)
- Compatible IDE (VS Code, Android Studio, IntelliJ)
- Device or emulator set up for running Flutter apps
- Internet access for API calls

### Installation

1. **Clone the repository:**

git clone https://github.com/yourusername/bytesymphony.git
cd bytesymphony


2. **Install dependencies:**

flutter pub get


3. **Run the app:**

Connect a device or start an emulator, then:

flutter run


4. **Login Credentials:**

Use demo credentials for testing:

- Email: `admin@demo.dev`
- Password: `Admin@123`

---

## API Details

- Base URL: `https://www.bytesymphony.dev/TestAPI`
- Use JWT Bearer token for authenticated routes.
- Live API Swagger for reference: `https://www.bytesymphony.dev/TestAPI/swagger/index.html`

---

## Project Structure

lib/
├── config/ # API configuration constants
├── models/ # Data model classes for User, Client, Invoice
├── services/ # API and storage services
├── screens/ # UI screens: login, home, clients, invoices
├── widgets/ # Reusable UI components: buttons, text fields, dialogs
└── main.dart # App entrypoint with routing and providers


---

## Key Packages

- [dio](https://pub.dev/packages/dio) – HTTP client with interceptor support
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) – Secure storage for tokens
- [provider](https://pub.dev/packages/provider) – State management
- [google_fonts](https://pub.dev/packages/google_fonts) – Custom typography
- [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) – Loading animations

---

## Usage

- **Login:** Authenticate with provided credentials to obtain JWT token.
- **Clients:** View paginated, searchable lists. Add/Edit or delete client entries.
- **Invoices:** Filter invoices by status or client.
- **Logout:** Securely log out with confirmation dialog.

---

## Development Tips

- Keep API token securely stored and refreshed on 401 errors.
- Use `CustomSnackBar` for consistent message display with truncation for long errors.
- Use the reusable `ConfirmationDialog` widget for user confirmations.
- Follow Flutter best practices for state management and UI responsiveness.
- Extend validation logic in form fields using regex to ensure data integrity.

---

## Troubleshooting

- **API errors:** Check internet connectivity; ensure API endpoint is reachable.
- **Token issues:** Delete token from secure storage manually if stuck and login again.
- **Build errors:** Run `flutter clean` and `flutter pub get` to reset dependencies.
- **UI glitches:** Restart app; check for Flutter SDK updates.

---

## Contribution

This is a sample project primarily for demonstration. Contributions for improved UI/UX, enhanced features, or bug fixes are welcome via pull requests.

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [ByteSymphony API Documentation](https://www.bytesymphony.dev/TestAPI/swagger/index.html)
- [Flutter Codelabs](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

## License

This project is private and confidential property of ByteSymphony Business Solutions LLP and used for technical testing purposes only.

---

*Happy coding with Flutter and ByteSymphony!* 🚀
