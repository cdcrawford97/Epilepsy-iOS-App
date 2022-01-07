<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
<h3 align="center">Carerilepsy - An Epilepsy Mobile App</h3>

  <p align="center">
    Native iOS app to assist epilepsy patients in the self-management of their condition.
    <br />
    <a href="https://github.com/cdcrawford97/Epilepsy-iOS-App"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/cdcrawford97/Epilepsy-iOS-App">View Demo</a>
    ·
    <a href="https://github.com/cdcrawford97/Epilepsy-iOS-App/issues">Report Bug</a>
    ·
    <a href="https://github.com/cdcrawford97/Epilepsy-iOS-App/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<kbd>
    <img src="/ReadmeImages/Image_1.png" />
</kbd>

The motivation for this project was to provide a mobile app that is free to use, includes the most essential features for a patient who's self-managing their own epilepsy whilst providing a healthcare collobaration feature which I found to be an underdeveloped area in the current epilepsy app market. 

<b>Solution</b>:
* Health communication - separate clinician and patient accounts can be created and linked together to enable the sharing of patient data and thus assist in monitoring the progression of a patient's condition.

<kbd>
    <img src="/ReadmeImages/Image_2.png" />
</kbd>

* Seizure tracking - the app incorporates a seizure diary, where seizures can be registered based on seizure date, time of occurrence, seizure type, triggers, and duration, with the natural sorting and ﬁltering of seizures by month and year.

<kbd>
    <img src="/ReadmeImages/Image_3.png" />
</kbd>

* Treatment management - treatments can be added to the app and local notiﬁcations can be setup for certain days/times as reminders for treatment times.

<kbd>
    <img src="/ReadmeImages/Image_4.png" />
</kbd>

* Medication adherence - the personalised home screen includes a list of the current treatments that need to be taken that day, as well as displaying relevant statistics relating to seizure count and treatment adherence via a graph and progress bar.

<kbd>
    <img src="/ReadmeImages/Image_5.png" />
</kbd>

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [SwiftUI](https://developer.apple.com/xcode/swiftui/) 
* [Swift](https://developer.apple.com/swift/) 
* [Firebase](https://firebase.google.com/) 


<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/cdcrawford97/Epilepsy-iOS-App
   ```
   
2. Set up a Firebase project to host the application's configuration and data. Please read the guide below.

## Connecting to the [Firebase Console](https://console.firebase.google.com)

We will need to connect the app with the [Firebase Console](https://console.firebase.google.com). For an in depth explanation, you can read more about [adding Firebase to your iOS Project](https://firebase.google.com/docs/ios/setup).

### Here's a summary of the steps!
1. Visit the [Firebase Console](https://console.firebase.google.com) and create a new app.
2. Add an iOS app to the project. Make sure the `Bundle Identifier` you set for this iOS App matches that of the one in this quickstart.
3. Download the `GoogleService-Info.plist` when prompted.
4. Drag the downloaded `GoogleService-Info.plist` into the opened Carerilepsy app. In Xcode, you can also add this file to the project by going to `File`-> `Add Files to 'AuthenticationExample'` and selecting the downloaded `.plist` file. Be sure to add the `.plist` file to the app's main target.
5. At this point, you can build and run the app! 🎉


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

- [x] Add authentication
- [x] Add patient and clinician UI & base features
- [ ] Add CoreData solution for offline data persistence (Progress bar component)
- [ ] Expand out the clinician dashboard statistics 
- [ ] Add multi language support 
    - [ ] Spanish
    - [ ] Chinese
- [ ] Publish to the Apple app store 


See the [open issues](https://github.com/cdcrawford97/Epilepsy-iOS-App/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [SwiftUICharts](https://github.com/AppPear/ChartView)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/cdcrawford97/Epilepsy-iOS-App.svg?style=for-the-badge
[contributors-url]: https://github.com/cdcrawford97/Epilepsy-iOS-App/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/cdcrawford97/Epilepsy-iOS-App.svg?style=for-the-badge
[forks-url]: https://github.com/cdcrawford97/Epilepsy-iOS-App/network/members
[stars-shield]: https://img.shields.io/github/stars/cdcrawford97/Epilepsy-iOS-App.svg?style=for-the-badge
[stars-url]: https://github.com/cdcrawford97/Epilepsy-iOS-App/stargazers
[issues-shield]: https://img.shields.io/github/issues/cdcrawford97/Epilepsy-iOS-App.svg?style=for-the-badge
[issues-url]: https://github.com/cdcrawford97/Epilepsy-iOS-App/issues
[license-shield]: https://img.shields.io/github/license/cdcrawford97/Epilepsy-iOS-App.svg?style=for-the-badge
[license-url]: https://github.com/cdcrawford97/Epilepsy-iOS-App/blob/master/LICENSE.txt
