MooLogue — ML-Driven Bioacoustic Analysis for Dairy Cattle Vocalizations

SoftwareX – Developer & Research Documentation

Overview

MooLogue is a cross-platform mobile application for analyzing dairy cow vocalizations using Flutter, Python-based machine learning, and a fully serverless backend built on AWS Lambda, S3, API Gateway, and DynamoDB.

The software enables farmers, researchers, and veterinarians to:

Record cow audio in real-time

Upload audio securely to AWS

Generate Mel-spectrograms

Run inference through a PyTorch CNN

Receive label + confidence + recommended action

Explore call types, quizzes, and interactive education

This repository hosts the public scientific release (v1.0) of the MooLogue client application used in the SoftwareX manuscript.

System Architecture
Mobile → Cloud Inference Pipeline
Flutter (Mobile App)
   |
   +--> Local audio recording (5–10 s, WAV)
   |
   +--> Upload to AWS S3
           |
           +--> Trigger AWS Lambda (Python)
                     |
                     +--> Librosa audio preprocessing
                     +--> Mel-spectrogram conversion
                     +--> PyTorch CNN classification
                     +--> Return JSON response
           |
           +--> Store metadata in DynamoDB
   |
   +--> Display inference in UI (label + probability + advice)

Repository Structure
moologue-app/
 ├── android/
 ├── ios/
 ├── lib/                      # Flutter client source code
 ├── assets/                   # Audio icons, illustrations
 ├── web/
 ├── test/
 ├── pubspec.yaml              # Dependencies
 ├── analysis_options.yaml
 └── README_softwarex.md       # Developer documentation

Dependencies

Flutter SDK ≥ 3.16

Dart ≥ 3.2

Python 3.9 (Lambda runtime)

Librosa, NumPy, SciPy

PyTorch (optimized CPU build)

AWS Services: S3, Lambda, API Gateway, DynamoDB

Installation
flutter pub get
flutter run

Citation

To cite MooLogue:

M. Kate and S. Neethirajan, (2025). MooLogue: A Cross-Platform Mobile Application for Cow Vocalization Analysis Using Flutter and AWS. SoftwareX. (In Review)

Contact

mooanalytica@gmail.com

https://github.com/mooanalytica/moologue-app
