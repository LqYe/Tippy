# Pre-work - *Tippy*

**Tippy** is a tip calculator application for IOS.

Submitted by: **LiQiang Ye**

Time spent: **12** hours spent in total
 
## User Stories
The following **required** functionality is complete:
* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
* [x] Created an app icon for the app.
* [x] Added launch screen background image.
* [x] Changed navigation bar UI.
* [x] Static tableview settings layout.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/2sPM58N.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis
Question 1: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")
 
Answer:  iOS app development is easier than I thought. I used to believe iOS development is complicated and time-consuming. But with Swift programing language and xocde’s simplified UI design, iOS app development is fun and fast. Currently, I still rely on many Youtube tutorials, stackoverflow answers and other online resources as I am new to swift iOS development. I hope to familiarize myself with swift syntax, iOS UI design, and other iOS development techniques during Codepath’s iOS bootcamp.
In my words, outlets and actions in iOS are just simple “drag and connect “ to exchange messages\events between UI and controllers\code.
iOS storyboard is just a virtual tool to help developers to drag and drop to lay out multiple application views, the transitions between them and connections from\to controllers. When “drag and drop” occurs, it creates corresponding xml elements in the storyboard xml source file. A outlet or action is an xml element with different attributes that associate with a UI xml element, for example, label. Objects and messages are created by using the xml element definition and passed to controllers during app start-up or running.

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"
 
Answer: define a property in the class and use a closure (code block)  that refers to other instance properties in the same class to assign its value.
 
## Credits
1. Basic Version: https://www.youtube.com/watch?v=lyR8w6zmxVc
2. Add background image to launch screen: https://www.youtube.com/watch?v=6ql8ZcPi8uU
3. Setting FirstResponder: https://developer.xamarin.com/recipes/ios/standard_controls/text_field/set-uitextfield-focus/
4. Slidebar: https://www.youtube.com/watch?v=nfQzPYA7X6E
5. Static Table View Settings: https://www.youtube.com/watch?v=VTfXfudzWxI
6. Customizing navigation bar appearance:
   1) https://coderwall.com/p/dyqrfa/customize-navigation-bar-appearance-with-swift
   2) https://makeapppie.com/2015/03/21/swift-swift-using-the-navigation-bar-title-and-back-button/
   3) https://stackoverflow.com/questions/21447327/ios7-what-is-the-difference-in-all-these-color-bartintcolor-tintcolor-backgr
7. Add App Icons
   1) http://appiconmaker.co/
   2) https://www.youtube.com/watch?v=m-zRNghYWkA


## License
 
    Copyright 2017 LiQiang Ye
 
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
 
        http://www.apache.org/licenses/LICENSE-2.0
 
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
