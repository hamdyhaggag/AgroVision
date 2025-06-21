<div align="center">
  <img src="assets/images/agrovision.png" alt="AgroVision Logo" width="150"/>
  <h1>AgroVision</h1>
  <p>Your Smart Farming Companion</p>
</div>

---

**AgroVision** is a comprehensive mobile application built with Flutter, designed to empower farmers with cutting-edge technology for modern agriculture. This app serves as an intelligent assistant, providing essential tools for crop disease detection, real-time farm monitoring, and streamlined management.

---

## ✨ Key Features

-   **🌱 AI-Powered Disease Detection:** Instantly identify plant diseases by uploading an image. Receive detailed information on the disease, its symptoms, and recommended treatment strategies.
-   **🛰️ Real-time Farm Monitoring:** Gain insights into your farm's health with live data from integrated IoT sensors, tracking:
    -   Soil Moisture
    -   Humidity
    -   Temperature
    -   Electrical Conductivity (EC)
    -   Soil Fertility
-   **💧 Smart Irrigation Control:** Optimize water usage by remotely controlling water pumps based on sensor data and predictive weather forecasts.
-   **🤖 AI Chatbot Assistant:** Get immediate answers to your farming queries through our integrated, AI-powered chatbot.
-   **👨‍🌾 Farmer Community Chat:** Connect and collaborate with a network of fellow farmers to share knowledge, experiences, and best practices.
-   **✅ Task Management:** Efficiently organize and manage your farming activities with a dedicated task management system.
-   **📊 Health & Analytics Dashboard:** Visualize critical farm data through interactive charts and gauges, facilitating informed decision-making.
-   **🌐 Multi-Language Support:** Available in both English and Arabic to cater to a diverse user base.
-   **🌓 Light & Dark Mode:** Enjoy comfortable viewing in any environment with seamless switching between light and dark themes.

---

## 📸 Screenshots

| Onboarding | Home Screen | Disease Detection |
| :---: | :---: | :---: |
| | | |
| **Sensor Monitoring** | **AI Chatbot** | **Dark Mode** |
| | | |

---

## 🛠️ Tech Stack & Architecture

This project is meticulously crafted using **Flutter** and adheres to a clean, feature-first architecture, ensuring high scalability, maintainability, and robust performance.

-   **Framework:** [Flutter](https://flutter.dev/)
-   **State Management:** [BLoC (Cubit)](https://bloclibrary.dev/)
-   **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
-   **Networking:** [Dio](https://pub.dev/packages/dio) & [Retrofit](https://pub.dev/packages/retrofit)
-   **Routing:** Custom Routing Implementation
-   **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences) & [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
-   **Localization:** [Easy Localization](https://pub.dev/packages/easy_localization)
-   **Real-time Communication:** [Socket.IO Client](https://pub.dev/packages/socket_io_client)
-   **Code Generation:** [Freezed](https://pub.dev/packages/freezed), [JSON Serializable](https://pub.dev/packages/json_serializable)
-   **UI Libraries:**
    -   [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil) for adaptive UI responsiveness.
    -   [Lottie](https://pub.dev/packages/lottie) for engaging animations.
    -   [FL Chart](https://pub.dev/packages/fl_chart) & [Syncfusion Gauges](https://pub.dev/packages/syncfusion_flutter_gauges) for sophisticated data visualization.

---

## 📂 Project Structure

The project is organized into a modular, feature-based structure, where each feature encapsulates its own data, business logic, and user interface components, promoting clear separation of concerns and ease of development.

```
lib/
├── core/             # Core utilities, services, themes, and configurations
│ ├── config/
│ ├── constants/
│ ├── dependency_injection/
│ ├── helpers/
│ ├── network/
│ ├── routing/
│ └── theme/
├── features/         # Feature-based modules (e.g., authentication, chat, monitoring)
│ ├── authentication/
│ ├── chat/
│ ├── disease_detection/
│ ├── home/
│ ├── monitoring/
│ └── ...             # Other feature modules
├── shared/           # Reusable widgets, services, and common components
└── main.dart         # Application entry point
```

---

## 🚀 Getting Started

Follow these steps to set up and run AgroVision on your local machine.

### Prerequisites

-   **Flutter SDK:** Version 3.5.0 or higher.
-   **Development Environment:** An IDE such as VS Code or Android Studio.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/hamdyhaggag/agro_vision.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd agro_vision
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Set up environment variables:**
    -   Create a `.env` file in the root of your project.
    -   Add any necessary API keys or configuration variables (e.g., `API_BASE_URL=your_api_base_url_here`). This step is crucial for the app to function correctly.

5.  **Run the code generator:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
6.  **Run the application:**
    ```bash
    flutter run
    ```

---

<div align="center">
  <p>Made with ❤️ for a greener future By Hamdy Haggag</p>
</div>