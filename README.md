# Project 1 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User sees app icon in home screen and styled launch screen (+1pt)
- [x] User can scroll through a list of movies currently playing in theaters from The Movie DB API (+5pt)
- [x] User can "Pull to refresh" the movie list (+2pt)
- [x] User sees a loading state while waiting for the movies to load (+2pt)

The following **stretch** user stories are implemented:

- [x] User sees an alert when there's a networking error (+1pt)
- [x] User can search for a movie (+3pt)
- [x] While poster is being fetched, user see's a placeholder image (+1pt)
- [x] User sees image transition for images coming from network, not when it is loaded from cache (+1pt)
- [x] Customize the selection effect of the cell (+1pt)
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete (+2pt)

The following **additional** user stories are implemented:

- [x] List anything else that you can get done to improve the app functionality! (+1-3pts)
I added a new controller, when user touches a row it will take them to where they can read more about the movie. Also They will see a poster of low resolution being fetched first followed by a high resolution poster movie. The change depends on connection will be visible or not. Most of time it is not visible. 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Memory cache, how much cache would we need ? and how to cash only high resolution images/posters.
2. ScrollView, Although I managed to make it work, what is the best way to set constraints to it and its items on top of it. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div style="display: inline-block;">
<img float="left" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/45395016-fcf5f480-b601-11e8-98e2-611a118bf087.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img float="right" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/45395336-ab4e6980-b603-11e8-9f2e-1c3cdf10e5cf.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<div/>

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
Challenges:
1) Memory cache! I don't understand why some images were cached and why others were not.

## License

Copyright [2018] [Luis Mendez]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


# Project 2 - *Flix*

**Name of your app** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can tap a cell to see a detail view (+5pts)
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView (+5pts)

The following **stretch** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie (+3pts)
- [x] In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer (+3pts)
- [x] Customize the navigation bar (+1pt)
- [x] List in any optionals you didn't finish from last week (+1-3pts)
        - Everything was finished last time

The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!

        1. I think I can play around more with WKWebView.
        2. I want to be able to edit the font of UIButtons set the foreground color, strokes, etc.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

        1. I think I can play around more with WKWebView.
        2. I want to be able to edit the font of UIButtons set the foreground color, strokes, etc.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div style="display: inline-block;">
<img float="left" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/45663864-b824fe80-bad6-11e8-8422-d9d785ab4cdd.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img float="right" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/45663892-dbe84480-bad6-11e8-8920-b40d3b44c4e6.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<div/>

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

        -WKWebView was a bit challenge, it seems that the load request is somewhat slow.
        -TapGestureRecognizer on an UIImage was a bit complicated, because of it my segue was not working.

## License

Copyright [2018] [Luis Mendez]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
