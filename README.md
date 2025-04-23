# AgroVision Mobile Application

**AgroVision** is a feature-rich, cross-platform mobile application designed to revolutionize agricultural management by providing real-time sensor monitoring, disease detection, order and inventory management, and multi-channel communication. Built with Flutter, Dart, and Cubit, the app delivers an intuitive and responsive user experience tailored for modern farming needs. 

---

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Technology Stack](#technology-stack)
5. [Installation](#installation)
6. [Usage](#usage)
7. [Project Structure](#project-structure)
8. [Testing](#testing)
9. [Contributing](#contributing)
10. [License](#license)
11. [Contact](#contact)

---

## Overview
AgroVision bridges field operations with centralized data analysis to enhance farm productivity and decision-making. Key functionalities include:
- **Real-Time Sensor Monitoring**: View live data on soil pH, temperature, humidity, and more. citeturn0file0
- **Crop Disease Detection**: Capture and analyze crop images for early disease diagnosis. citeturn0file0
- **Order & Inventory Management**: Track orders, financials, and stock levels seamlessly. citeturn0file0
- **Multi-Channel Communication**: Chat with a chatbot or directly with farmers and e-commerce clients. citeturn0file0

## Features
- **Splash & Onboarding** with live sensor metrics and weather data.
- **Secure Authentication** with instant feedback and contextual weather info.
- **Dashboard**: Quick actions for crop health, tasks, sensor data, and detection history.
- **Disease Detection**: In-app image processing with confidence scores and recommendations.
- **Detailed Sensor Module**: Real-time and historical data visualization.
- **Order Analytics**: Comprehensive reporting of transactions and invoice statistics.
- **Chats**: Tabbed interface for chatbot (Khedr) and peer communication.
- **Settings**: Profile, notifications, dark mode, feedback, and logout.
- **Farm Inventory**: Categorized produce management with dynamic pricing and stock status. citeturn0file0

## Architecture
AgroVision employs a **feature-based modular architecture** for scalability and maintainability: citeturn0file0
- **Core** (`lib/core`): Constants, DI, helpers, network, themes.
- **Features** (`lib/features`): Encapsulated modules (API, repository, model, logic, UI).
- **Shared** (`lib/shared`): Common widgets and services.
- **Global Models** (`lib/models`): Cross-cutting data structures.

State management is handled via **Cubit**, decoupling UI from business logic and ensuring real-time responsiveness. citeturn0file0

## Technology Stack
| Layer                 | Technology                |
|-----------------------|---------------------------|
| Framework             | Flutter                   |
| Language              | Dart                      |
| State Management      | Cubit (BLoC Library)      |
| IDE                   | VS Code, Android Studio   |
| Version Control       | Git / GitHub              |
| Testing               | Unit, Integration, UI     |

## Installation
1. **Prerequisites**:
   - Flutter SDK ≥ 3.x
   - Dart ≥ 2.x
   - Git
2. **Clone the repository**:
   ```bash
   git clone https://github.com/your-org/agrovision-mobile.git
   cd agrovision-mobile
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run on device/emulator**:
   ```bash
   flutter run
   ```

## Usage
- **Login** with your credentials to access the dashboard.
- **Navigate** using the bottom navigation bar to access modules: Home, Disease Detection, Sensor Data, Chats.
- **Open the drawer** for Order Analytics, Inventory, and Settings.

## Screenshots

### Splash & Onboarding & Login (6 images)

| Splash 1 | Splash 2 | Splash 3 |
|:--------:|:--------:|:--------:|
| ![Splash 1](screenshots/splash1.png) | ![Splash 2](screenshots/splash2.png) | ![Splash 3](screenshots/splash3.png) |
| Splash 4 | Splash 5 | Splash 6 |
| ![Splash 4](screenshots/splash4.png) | ![Splash 5](screenshots/splash5.png) | ![Splash 6](screenshots/splash6.png) |

### Home (3 images)

| Home 1 | Home 2 | Home 3 |
|:------:|:------:|:------:|
| ![Home 1](screenshots/home1.png) | ![Home 2](screenshots/home2.png) | ![Home 3](screenshots/home3.png) |

### Disease Detection (4 images)

| Detect 1 | Detect 2 |
|:--------:|:--------:|
| ![Detect 1](screenshots/detect1.png) | ![Detect 2](screenshots/detect2.png) |
| Detect 3 | Detect 4 |
| ![Detect 3](screenshots/detect3.png) | ![Detect 4](screenshots/detect4.png) |

### Sensor Data (2 images)

| Sensor 1 | Sensor 2 |
|:--------:|:--------:|
| ![Sensor 1](screenshots/sensor1.png) | ![Sensor 2](screenshots/sensor2.png) |

### Recommendation (2 images)

| Rec 1 | Rec 2 |
|:-----:|:-----:|
| ![Rec 1](screenshots/rec1.png) | ![Rec 2](screenshots/rec2.png) |

### Tasks (3 images)

| Task 1 | Task 2 | Task 3 |
|:------:|:------:|:------:|
| ![Task 1](screenshots/task1.png) | ![Task 2](screenshots/task2.png) | ![Task 3](screenshots/task3.png) |

### Drawer

#### Order Analytics (4 images)

| Order 1 | Order 2 |
|:-------:|:-------:|
| ![Order 1](screenshots/order1.png) | ![Order 2](screenshots/order2.png) |
| Order 3 | Order 4 |
| ![Order 3](screenshots/order3.png) | ![Order 4](screenshots/order4.png) |

#### Farm Inventory (1 image)

| Farm Inventory |
|:--------------:|
| ![Farm Inventory](screenshots/farm_inventory.png) |

#### Settings (2 images)

| Settings 1 | Settings 2 |
|:----------:|:----------:|
| ![Settings 1](screenshots/settings1.png) | ![Settings 2](screenshots/settings2.png) |

## Project Structure
### 1. lib Structure
```
lib/
├── core/
├── features/
│   ├── auth/
│   ├── disease_detection/
│   ├── sensor_data/
│   ├── order_management/
│   └── chat/
├── shared/
└── models/
```

### 2. core Structure
```
core
├── constants
│   ├── app_assets.dart
│   └── constant.dart
│
├── dependency_injection
│   └── di.dart
│
├── helpers
│   ├── app_localizations.dart
│   ├── app_regexp.dart
│   ├── cache_helper.dart
│   ├── enums.dart
│   ├── extensions.dart
│   ├── location_helper.dart
│   ├── spaces.dart
│   ├── validations.dart
│   └── voice_recorder_utility.dart
│
├── network
│   ├── api_constants.dart
│   ├── api_error_handler.dart
│   ├── api_error_model.dart
│   ├── api_error_model.g.dart
│   ├── api_result.dart
│   ├── api_result_freezed.dart
│   ├── api_service.dart
│   ├── api_service.g.dart
│   ├── dio_factory.dart
│   └── weather_service.dart
│
├── routing
│   ├── app_router.dart
│   └── app_routes.dart
│
├── theme
│   └── theme_cubit
│       ├── theme_cubit.dart
│       └── theme_state.dart
│   ├── dark_theme.dart
│   └── light_theme.dart
│
├── themes
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── font_weights.dart
│   └── text_styles.dart
│
└── utils
    ├── functions.dart
    └── utils.dart

```
## Testing
- **Unit Tests**: `flutter test test/unit`
- **Integration Tests**: `flutter test integration_test`
- **UI Tests**: Use `flutter drive` with configured emulators.

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/YourFeature`.
3. Commit changes: `git commit -m "Add YourFeature"`.
4. Push: `git push origin feature/YourFeature`.
5. Open a Pull Request.

Please adhere to the existing code style and include relevant tests.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contact
Maintainer: **Your Name**
Email: your.email@example.com
GitHub: [your-org/agrovision-mobile](https://github.com/your-org/agrovision-mobile)

