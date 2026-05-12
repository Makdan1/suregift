# SureGift - VoucherHub Integration

## 📱 Project Showcase

<p align="center">
  <img src="assets/screenshots/splash_anim.gif" width="200" title="Animated Splash">
  <img src="assets/screenshots/home.png" width="200" title="Product Catalogue">
  <img src="assets/screenshots/details.png" width="200" title="Product Details">
  <img src="assets/screenshots/cart.png" width="200" title="Shopping Cart">
</p>

---

## 🚀 Overview
SureGift is a premium mobile application built with Flutter that integrates with the **VoucherHub API**. It provides a seamless end-to-end experience for browsing, purchasing, and managing digital gift cards.

## 🛠️ How it is Built (Architecture)
The app follows **Clean Architecture** principles combined with the **MVVM (Model-View-ViewModel)** pattern. This ensures a strict separation of concerns, making the codebase maintainable and testable.

### 1. Layered Structure
- **Data Layer (`/data`)**: Handles API communication, data models (JSON serialization), and local storage (Secure Storage).
- **Presentation Layer (`/presentation`)**: Contains Flutter widgets and **Riverpod Notifiers** (ViewModels) that manage UI state.
- **Core Layer (`/core`)**: Shared utilities like network clients (Dio), theme configuration, and common widgets.

### 2. State Management
We use **Riverpod 2.0** for reactive state management. It allows us to:
- Cache API responses efficiently.
- Handle loading/error states globally.
- Decouple business logic from the UI.

### 3. Networking
Built on **Dio**, featuring:
- **Interceptors**: Automatically attaches JWT tokens to outgoing requests.
- **Error Handling**: Graceful technical error mapping to user-friendly messages.

---

## 🔄 App Flow & Logic

### 1. Launch & Authentication
- **Splash Screen**: Checks for an existing session. If a valid JWT is found, it directs to the Home screen; otherwise, it shows the Login screen.
- **Login**: Authenticates with the VoucherHub API and securely stores the `accessToken` using `FlutterSecureStorage`.

### 2. Browsing & Searching
- **Product Catalogue**: Fetches a real-time list of gift cards.
- **Search**: A local search implementation that filters products by name, description, or category instantly as the user types.
- **Animations**: Staggered entrance animations and Hero transitions provide a premium, fluid feel.

### 3. Purchase Journey
- **Product Details**: Allows users to select denominations or enter custom amounts.
- **Shopping Cart**: A persistent state that tracks items, quantities, and subtotal. Includes a real-time badge on the home screen.
- **Checkout**: Posts the order to the API and clears the local cart upon success.

### 4. Voucher Management
- **History**: Displays a list of all successful purchases.
- **Details**: Fetches granular data for a specific voucher, including redemption codes, instructions, and operational history.

---

## 🧪 Testing Strategy

The app includes a robust suite of unit tests focusing on the **Repository Layer** (the heart of the data flow).

### 1. Mocking with `Mocktail`
We use `mocktail` to create a `MockDio` and `MockSecureStorage`. This allows us to simulate:
- Successful API responses (200 OK).
- API errors (401 Unauthorized, 500 Server Error).
- Persistent storage operations.

### 2. Test Case Logic
- **AuthRepository Tests**:
    - Verifies that a successful login correctly parses the JSON response.
    - Verifies that the JWT token is actually saved to secure storage.
    - Ensures proper error propagation when the API fails.
- **ProductRepository Tests**:
    - Verifies that the catalogue is correctly transformed from raw JSON into strongly-typed Dart models.
    - Ensures that empty states are handled gracefully.

---

## ✨ Features
- **Premium UI/UX**: Shimmer loading effects, staggered animations, and brand-consistent theming (SureGift Red).
- **Secure**: JWT-based authentication and secure credential storage.
- **Fast**: Optimized scrolling with `cacheExtent` and efficient state caching.

## 🏁 Getting Started

### Installation
1. Clone the repository.
2. Run `flutter pub get`.
3. Run `dart run build_runner build --delete-conflicting-outputs` (to generate JSON models).
4. Launch the app: `flutter run`.

### Running Tests
```bash
flutter test
```

### Test Credentials
- **Email**: test@mail.com
- **Password**: Password1@
