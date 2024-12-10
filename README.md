# Attendease 📊

**Attendease** is a Flutter-based mobile application designed to generate and display attendance reports for students. By integrating with Firebase Firestore and Firebase Authentication, the app provides an interactive and dynamic way to track attendance data for various subjects.

---

## Features

- **User Authentication**:
  - Login using Firebase Authentication.
  
- **Attendance Tracking**:
  - Automatically fetch and calculate attendance for different subjects.
  - Calculate and display attendance percentages for each subject.

- **Dynamic Reports**:
  - View attendance details with a percentage indicator.
  - Highlights subjects with low attendance for better tracking.

- **Interactive UI**:
  - Modern and responsive design.
  - Color-coded progress indicators to visually represent attendance status.

---

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Auth
- **State Management**: Flutter's `StatefulWidget`

---

## Screenshots

Include screenshots of your app here. For example:

- **Home Page**: Overview of subjects and attendance percentages.
- **Detailed Reports**: A card for each subject showing attendance details.

---

## Installation

Follow these steps to run the app on your local machine:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/attendease.git
   cd attendease
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**:
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add a new Android/iOS app and download the `google-services.json` or `GoogleService-Info.plist`.
   - Place the file in the `android/app` or `ios/Runner` folder respectively.
   - Configure Firestore collections as described below.

4. **Run the App**:
   ```bash
   flutter run
   ```

---

## Firebase Setup

Ensure the following Firestore collections and documents are configured:

1. **User Collection**: 
   ```
   <user-id>/Semester/<semester-number>/Subjects
   ```
   - **Fields**:
     - `subjects`: List of objects containing:
       - `subcode`: Subject code.
       - `subname`: Subject name.

2. **Attendance Collection**:
   ```
   <user-id>/Attendence/<semester-number>
   ```
   - **Fields**:
     - `subjects`: List of objects containing:
       - `subcode`: Subject code.
       - `attended`: Boolean (true if the class was attended).

---

## How It Works

1. **Authentication**:
   - The app identifies users based on Firebase Authentication.

2. **Fetch Data**:
   - Retrieves subjects and attendance data from Firestore collections.

3. **Calculate Attendance**:
   - Computes attendance percentages based on total classes and attended classes.

4. **Display Data**:
   - Presents data with an intuitive progress indicator for each subject.
5. **Analytics**:
  - Generate monthly attendance analytics.
  
6. **Multi-Semester Support**:
  - Add support for tracking multiple semesters simultaneously.

---

## Upcoming Features

- **Notifications**:
  - Send alerts for low attendance subjects.
---

## Contributing

We welcome contributions! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add a meaningful commit message"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

## Contact

If you have any questions or suggestions, feel free to reach out:

- **Email**: shanmukhasrinivas82@gmail.com
- **LinkedIn**: [LinkedIn Profile](https://www.linkedin.com/in/shannu6637/)

---
