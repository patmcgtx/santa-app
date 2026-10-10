# Where in the World is Santa Claus?

An early augmented-reality iPhone app: point the camera, and find Santa where he really is. Built in Objective-C with UIKit and cocos2d, years before ARKit, RealityKit or Swift.

[![Santa AR demo video](https://img.youtube.com/vi/QVSe75pNovg/hqdefault.jpg)](https://youtu.be/QVSe75pNovg)

<!-- TODO: add a short hero GIF at assets/santa-app.gif above this thumbnail, and keep the thumbnail as the full demo -->

**Role:** designer, developer, QA, release, and marketing (solo) · **Built:** 2011–2013 · **Studio:** Round Trip Software
**Stack:** Objective-C, UIKit, cocos2d, Core Motion, Core Location, AVFoundation · **Status:** no longer on the App Store · **Localized into 8 languages**

- [Demo video](https://youtu.be/QVSe75pNovg?si=VdaxMjjo7Rvl3Na_)
- [More info on the Round Trip Software site](https://roundtripsoftware.wordpress.com/where-in-the-world-is-santa-claus/)

## The idea

When the iPhone came out, I wanted to change careers and become a mobile developer. I was working full-time on web and backend software, so I started with a side project to get there.

The spark came while standing on a beach, looking at the horizon and wondering what was out there past what I could see. An augmented-reality "what's out there" app felt like the right way to learn the platform. I narrowed it to Santa, for my kids and to keep the scope focused.

## What it does

- Shows the live camera view with an animated Santa overlaid on it
- Santa has a daily schedule, so he's doing something different depending on the time and date: preparing the reindeer, delivering presents on Christmas Eve, celebrating on Christmas, and following a normal routine the rest of the year
- Uses your location and the phone's motion sensors to work out whether Santa is on screen, off to your left or right, or almost in view
- Gives feedback as you home in on him, then locks on when he's in view
- Includes sound effects, a parental gate, and localization in 8 languages

Point the phone toward Santa and he appears on screen, blinking, so a child can tell they've found him.

## How it's built

- **About 9,200 lines of my own Objective-C**, on top of the open-source cocos2d engine.
- **Camera plus game layer.** A live camera preview sits under a cocos2d view that draws Santa. The game view ignores touches, and all interaction goes through UIKit.
- **Sensor-driven positioning.** Core Location gives the phone's position, Core Motion gives its orientation, and a landmark-to-screen mapper turns a real-world latitude and longitude into an on-screen position. Parts of the math follow Apple's pARk sample app.
- **A state machine for the main screen.** Sleeping, locating the device, location disabled, Santa off screen left or right, and Santa on screen (not locked, almost locked, locked) are each their own state class, which kept the transitions clear as the behavior grew.
- **Observer and notification patterns.** A watcher compares old and new state and notifies observers only when something changes.
- **A time-based schedule** that decides what Santa is doing, written as an explicit rule list to match what the design called for.
- **Early-era constraints:** targets iOS 5.0, with Core Data for the landmark data.

## What I learned

I assumed an AR Santa tracker would be easy. It took Objective-C and Xcode, location and motion sensors, audio and animation, Core Data, state-pattern design, linear algebra, App Store submission, children's privacy compliance and localization. It was my first iPhone app and the project that made me a mobile developer. [Read my retrospective](https://mentalbreaktown.blog/2022/04/11/what-you-can-see-here-is-that-i-was-learning/).

## Screenshots

<img width="320" height="180" alt="Where in the World is Santa Claus? screenshot" src="https://github.com/user-attachments/assets/6609ff3f-28c2-44f2-ba4e-bf4e9b906869" />
<img width="320" height="180" alt="Where in the World is Santa Claus? screenshot" src="https://github.com/user-attachments/assets/50cf2dd1-c07b-4b2e-9016-812582e01d6a" />
<img width="320" height="180" alt="Where in the World is Santa Claus? 4-inch screenshot" src="https://github.com/user-attachments/assets/dc78116b-df7c-4707-91a8-9d5b2778ce8c" />
