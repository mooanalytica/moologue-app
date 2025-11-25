MooLogue — ML-Driven Bioacoustic Analysis for Dairy Cattle Vocalizations

This version (v1.0) is the official scientific release of the MooLogue application.

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

| Nr     | Code metadata description                               | Metadata                                                                                                                                                            |
| ------ | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **C1** | Current code version                                    | **v1.0**                                                                                                                                                            |
| **C2** | Permanent link to code/repository used for this version | **[https://github.com/mooanalytica/moologue-app](https://github.com/mooanalytica/moologue-app)**                                                                    |
| **C3** | Permanent link to reproducible capsule                  | **[https://github.com/mooanalytica/moologue-app/tree/main/examples](https://github.com/mooanalytica/moologue-app/tree/main/examples)**                              |
| **C4** | Legal code license                                      | **MIT License**                                                                                                                                                     |
| **C5** | Code versioning system used                             | **git**                                                                                                                                                             |
| **C6** | Software code languages, tools, services                | **Flutter (Dart), Python 3.9, PyTorch, Librosa, AWS Lambda, AWS S3, AWS API Gateway, DynamoDB**                                                                     |
| **C7** | Compilation requirements, OS, dependencies              | **Flutter SDK ≥ 3.16; Dart ≥ 3.2; Python ≥ 3.9; Dependencies: provider, audioplayers, http, shared_preferences, librosa 0.10, boto3, torch; Android 10+, iOS 14+.** |
| **C8** | Developer documentation                                 | **README_softwarex.md**                                                                                                                                             |
| **C9** | Support email                                           | **[mooanalytica@gmail.com](mailto:mooanalytica@gmail.com)**                                                                                                         |

