# ARKit-Invader

![](README_images/ARKit-Invader_logo.jpeg)

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![iOS](http://img.shields.io/badge/iOS-13.0-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![ARKit](http://img.shields.io/badge/ARKit-3.0-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@1901drama-yellow.svg?style=flat)](http://twitter.com/1901drama)

ARKit-Invader is a collection of ARKit3 samples.


# How to build

1.Download this Repository.

2.Open `ARKit-Invader.xcodeproj` with Xcode 11 and build it.

※It can **NOT** run on **Simulator**. Most functions require an A12 chip.


# Contents

## Coaching UI
![](README_images/CoachingUI.gif)

A function to display an animation for acquiring environmental data.

【Sample】[CoachingUI_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/CoachingUI_ViewController.swift)
【Document】[ARCoachingOverlayView](https://developer.apple.com/documentation/arkit/arcoachingoverlayview)



## People Occlusion 2D
![](README_images/PeopleOcclusion2D.gif)

A function that displays the user's body in front of 3D objects.

【Sample】[PeopleOcclusion2D_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/PeopleOcclusion2D_ViewController.swift)
【Document】[personSegmentation](https://developer.apple.com/documentation/arkit/arconfiguration/framesemantics/3089125-personsegmentation)



## People Occlusion 3D
![](README_images/PeopleOcclusion3D.gif)

A function that reflects and displays the context of the user's body and 3D objects.

【Sample】[PeopleOcclusion3D_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/PeopleOcclusion3D_ViewController.swift)
【Document】[personSegmentationWithDepth](https://developer.apple.com/documentation/arkit/arconfiguration/framesemantics/3194576-personsegmentationwithdepth)



## Motion Capture 2D
![](README_images/MotionCapture2D.gif)

([参考：ラジオ体操第一・実演](https://www.youtube.com/watch?v=_YZZfaMGEOU))

A function that can acquire the position of the user's body / joint using the position coordinates on the screen.

【Sample】[MotionCapture2D_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/MotionCapture2D_ViewController.swift)
【Document】[bodyDetection](https://developer.apple.com/documentation/arkit/arconfiguration/framesemantics/3214027-bodydetection)



## Motion Capture 3D
![](README_images/MotionCapture3D.gif)

([参考：ラジオ体操第一・実演](https://www.youtube.com/watch?v=_YZZfaMGEOU))

A function that can acquire the position of the user's body / joint in spatial coordinates.

【Sample】[MotionCapture3D_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/MotionCapture3D_ViewController.swift)
【Document】[ARBodyTrackingConfiguration](https://developer.apple.com/documentation/arkit/arbodytrackingconfiguration)



## Multiple Face Tracking
![](README_images/.gif)

A function that simultaneously tracks the location and facial expression of up to three people.

【Sample】[MultipleFaceTracking_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/MultipleFaceTracking_ViewController.swift)
【Document】[maximumNumberOfTrackedFaces](https://developer.apple.com/documentation/arkit/arfacetrackingconfiguration/3192187-maximumnumberoftrackedfaces)



## Simultaneous Front and Back Camera
![](README_images/SimultaneousCamera.gif)

A function that allows AR to be used simultaneously with the front and rear cameras.

【Sample】[SimultaneousCamera_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/SimultaneousCamera_ViewController.swift)
【Document】[supportsUserFaceTracking](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration/3223421-supportsuserfacetracking)



## Collaborative Sessions
![](README_images/CollaborativeSessions_A.gif)
![](README_images/CollaborativeSessions_B.gif)

Ability to help share AR experiences with other users.

【Sample】[CollaborativeSessions_ViewController.swift](https://github.com/1901drama/ARKit-Invader/blob/master/ARKit-Invader/Menu/CollaborativeSessions_ViewController.swift)
【Document】[isCollaborationEnabled](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration/3152987-iscollaborationenabled), [MultipeerConnectivity
](https://developer.apple.com/documentation/multipeerconnectivity)([Creating a Multiuser AR Experience](https://developer.apple.com/documentation/arkit/creating_a_multiuser_ar_experience))



# Details

Qiita https://qiita.com/1901drama/

GitHub https://github.com/1901drama/ARKit-Invader

☆ (star), 👍 (like) etc. If you can give feedback, I will do my best, so thank you!
