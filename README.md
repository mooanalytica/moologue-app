# MooLogue — The Language of Cows
--------------------------------------------------------------------------


## About MooLogue
Ever wondered what cows are really saying? With MooLogue, the daily chatter of the barn comes alive. This engaging, science-backed app lets you explore the hidden world of cow communication through an interactive soundboard of real dairy cow vocalizations.

Developed from cutting-edge research by the MooAnalytica Lab at Dalhousie University, Canada, MooLogue offers more than 45 categories of authentic Holstein and Jersey cow calls, captured directly from working dairy farms. From maternal reassurance moos to playful rumbles, from feeding anticipation calls to subtle distress signals, MooLogue reveals the social soundtrack of the barn like never before.


### What you will find inside MooLogue:
- **Soundboard Explorer** – Tap and listen to more than 300 curated cow vocalizations collected from Canadian dairy farms.
- **Call Categories** – Learn the difference between “I am hungry,” “I am in pain,” “Come here, calf,” and specialized estrus calls.
- **Quiz Mode** – Test your knowledge. Can you identify whether a call is maternal, social, or distressed?
- **Visual Learning** – Comic-style farm illustrations bring each call to life for immersive, educational fun.
- **Farmer-Friendly Insights** – Practical explanations for farmers, students, and animal lovers on interpreting herd behaviour and welfare.



### Why MooLogue Matters
Cows do not moo randomly. Their voices carry emotion, intent, and, in some cases, early indicators of health or welfare challenges. MooLogue opens a window into the social lives of cows—helpful for:
- **Dairy farmers** wanting better herd insight and welfare detection
- **Students & researchers** in animal behaviour and digital agriculture
- **Animal lovers** hoping to connect with barnyard voices in an informed and playful way



### Key Features Overview
- Over 45 call categories with clear explanations
- Farm-recorded audio validated by animal welfare researchers
- Interactive quizzes for both fun and training
- Offline use: works in barns, classrooms, research settings
- Free to explore—just listen and learn!



### Educational, Quirky, and Research-Based
MooLogue is the Duolingo of cow language—accessible for children, practical for farmers, and academically founded for researchers. Playful design meets meaningful science.



### Behind the Scenes
Over 1000 hours of field recordings from Canadian barns, meticulously categorized by experts in livestock bioacoustics.



### Why Download MooLogue?
Because in the barn, every sound matters. By listening closely, we can better understand the needs, emotions, and welfare of cows. MooLogue transforms livestock communication into actionable insights for all.



### MooLogue Points & Badges System
---------------------------------------------------------------------------------------

Earn points and badges as you explore, learn, and play in MooLogue!

###  Listening to Sounds
- **+2 pts:** Play a new (unique) sound in your session
-  No cooldown—replay as often as you want in a session!


###  Viewing Sound Details
- **+1 pt:** Tap “Learn More” on any sound
- Encourages you to dive deeper and discover more.

###  Taking Quizzes
- **+3 pts:** Each correct quiz answer
- **+1 pt:** Quiz attempt, even for wrong answers
- **+5 pts:** Bonus for finishing a quiz (score doesn’t matter)

###  Badges (Motivation Only)
- Collect badges like **“Sound Explorer”** or **“Quiz Starter”**
- Badges decorate your profile and leaderboard, making progress visual and fun!

---


###  Example Points Calculation

| Action                                  | Points                                 |
|------------------------------------------|----------------------------------------|
| Played 5 sounds                         | 5 × 2 = 10 pts                         |
| Viewed details for 3 sounds              | 3 × 1 = 3 pts                          |
| Took a quiz (5 questions, 3 correct)     | 3 × 3 = 9 + 1 (attempt) + 5 (bonus) = 15 pts |
| **Total for 1 session**                  | **28 points**                          |

---


###  Backend Trigger Events

Each point action is awarded via simple event triggers:
- `onSoundPlay(id)` 
- `onLearnTap(id)`
- `onQuizStart(id)` 
- `onQuizAnswer(correct)`
- `onQuizComplete(id)` 

*All points awarded in-session, no cooldowns or streak tracking. You may set a daily maximum if needed for fairness (e.g., 100 pts/day).* 

---


##  Features

- User Authentication (Sign Up / Login / Forgot Password)
- User Profile Management
- Dark & Light Mode
- Adjustable Text Size
- Play Audio Files
- Interactive Quizzes
- Backend-driven Content
- Clean, Responsive & Modern UI

---


## Tech Stack

| Component        | Technology            |
|------------------|----------------------|
| Framework        | Flutter (Dart)       |
| Backend          | Firebase             |
| Database         | Firestore            |
| State Management | GetX / Provider      |
| Authentication   | Firebase Auth        |
| IDE              | Android Studio, VS Code |

---


## Folder Structure

```text
project_root/
│
├── lib/            # Application source code
├── assets/         # Images, audio, fonts
├── android/        # Android-specific files
├── ios/            # iOS-specific files
├── web/            # Web files (optional)
├── pubspec.yaml    # Flutter dependency file
└── README.md       # This file
```

---


## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Device or emulator for testing

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
```

### 2️⃣ Install Dependencies & Run

```bash
flutter pub get
flutter run
```

> Be sure to update environment files and Firebase configuration as required for your project.

---

## Build Commands

To build a release APK:
```bash
flutter build apk --release
```
APK will be located in:
```
build/app/outputs/apk/release/
```

---

## iOS Configuration

### Prerequisites
- macOS with [Xcode](https://developer.apple.com/xcode/) installed
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) (`sudo gem install cocoapods`)

### iOS Setup Steps
1. **Install Dependencies for iOS:**
```bash
cd ios
pod install
cd ..
```

2. **Firebase (if using):**
   - Download your `GoogleService-Info.plist` from the Firebase Console.
   - Place it in the `ios/Runner/` directory.

3. **Open with Xcode (for Simulator or Real Device):**
```bash
open ios/Runner.xcworkspace
```
   - You can also use `flutter run` for simulator or device.

4. **Run the App:**
   - In Xcode, select a device or simulator and click the 'Run' ️ button.
   - Or, use `flutter run` in your terminal (make sure an iOS simulator is open).

### Additional Notes
- Make sure all necessary permissions (Camera, Microphone, etc.) are set in `ios/Runner/Info.plist`.
- For real devices, you may need a paid developer account and provisioning profile.
- If you have issues with CocoaPods, run `pod repo update` or `pod install --repo-update`.

---

##  Troubleshooting

| Issue             | Solution                                   |
|-------------------|--------------------------------------------|
| Web not working   | Run `flutter config --enable-web`          |
| Gradle build fail | Run `flutter clean` then `flutter pub get` |
| Backend issues    | Check Firebase configs                     |

---

##  Contributing

Pull requests are welcome! For significant changes, please open an issue first to discuss what you would like to change.

---

##  Support
https://mooanalytica.com/contact-us/

---

##  Privacy Policy
https://www.freeprivacypolicy.com/live/349ac534-a7df-4606-a6b5-97d6e2ea74af

---

##  Copyright
2025 Suresh Neethirajan

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
   
 
