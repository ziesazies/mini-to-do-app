# 📋 To-Do List App with Flutter + Bloc

A simple and elegant To-Do List mobile application built using **Flutter**, **Bloc** for state management, and **SharedPreferences** for local storage. Users can add, edit, delete, and categorize todos locally with persistent data even after restarting the app.

---

## 🚀 Flutter Version

- **Flutter SDK**: `>=3.29.3`
- **Dart**: `>=3.7.2`
---

## 📦 Project Specifications

- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Routing**: Flutter's built-in `Navigator`
- **UI**: Material 3 design, modern card-style layout
- **Architecture**: Clean separation between UI, logic (Bloc), and storage layer

---

## 🛠️ Project Setup & Build Instructions

1. **Clone this repository**:
   ```bash
   git clone https://github.com/your-username/todo-flutter-app.git
   cd todo-flutter-app
2. **Install dependencies**
   ```bash 
   flutter pub get
3. **Run the App**
   ```bash
   flutter run
4. **Login username and password**
   ```bash
   username: admin
   password: admin
✅ The app should build and run without error after following these steps.

# 🧱 Folder Structure
```bash
lib/
├── data/
│   └── datasources/        # Local storage handling with SharedPreferences
├── domain/                 # Data models (Todo, Category)
├── presentation/           
│   └── blocs/              # Bloc logic (events, states, bloc)
│     └── category/
│     └── login/
│     └── todo/
│   └── pages/              # UI pages (Login, Todo List, Add/Edit Todo)
├── widgets/               # Reusable UI components
├── models/                # Data models (Todo, Category)
├── widgets/               # Reusable UI components
└── main.dart              # App entry point
```

# ✨ Features
* 🔐 Login Screen
    * Hardcoded username & password
    * Simple validation
* ✅ CRUD To-Do
    * Create, edit, delete, and mark todos as done
    * Clean and responsive UI
* 🗂 Category System
    * Select or create new categories when adding todos
    * Named-based category indicator
* 📥 Local Persistence
    * All data is saved locally using SharedPreferences
    * Persistent across app restarts
* 🎯 Clean Architecture
    * Bloc pattern with separation of concerns
    * Easy to maintain and scale
# 🌱 Upcoming Features
These enhancements are in the roadmap for future development:
* 🎨 Emoji Picker for Categories
Add emojis to visually represent categories
* 📆 Deadline Date Filtering
Filter tasks based on due dates or overdue status
* 🧩 Multi-Category Section View
View todos grouped by category in collapsible/expandable sections
* 🔗 Firebase Integration
Cloud Firestore for real-time sync and data backup
Support for both online and offline modes
* 🔐 Google Authentication
Replace hardcoded login with Google Sign-In
Seamless and secure user management

# 📄 License
###### This project is open source and available under the MIT License.

# 📸 Preview
* Login Page
* To Do List Page
* To Do Detail Page
* Filter by Category Page
<p float="left">
   <img src="https://github.com/ziesazies/mini-to-do-app/blob/docs/docs/images/pic1.png?raw=true" width="150" height="280">
   <img src="https://github.com/ziesazies/mini-to-do-app/blob/docs/docs/images/pic4.png?raw=true" width="150" height="280">
   <img src="https://github.com/ziesazies/mini-to-do-app/blob/docs/docs/images/pic5.png?raw=true" width="150" height="280">
   <img src="https://github.com/ziesazies/mini-to-do-app/blob/docs/docs/images/pic11.png?raw=true" width="150" height="280">
</p>
