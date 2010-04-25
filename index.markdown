---
layout: pages
title: About
---

### Relay

Relay is an iPad application that allows you to intuitively transfer tasks between your computer and your iPad. Whatever you're doing—reading webpages, listening to music, copying and pasting—Relay allows you transfer that in progress task to the other device so that you can continue working without interruption.


### User Interaction

The UI metaphor we are currently using is that of flinging (or slinging? maybe throwing?). Fling items from the list in the iPad app towards the image of the computer to transfer that task to your computer. Fling a window towards one side of the screen on your computer to transfer the task being completed in that window to your iPad.

Some YouTube video demos of this interaction:

[Transferring watching a YouTube video from a Mac to an iPad](http://www.youtube.com/watch?v=oYpL6a2GDYA)

<object width="853" height="505"><param name="movie" value="http://www.youtube.com/v/oYpL6a2GDYA&hl=en_US&fs=1&rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/oYpL6a2GDYA&hl=en_US&fs=1&rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="853" height="505"></embed></object>

[Transferring a Google Map from a Mac to an iPad](http://www.youtube.com/watch?v=6xZkCSeVun0)

<object width="853" height="505"><param name="movie" value="http://www.youtube.com/v/6xZkCSeVun0&hl=en_US&fs=1&rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/6xZkCSeVun0&hl=en_US&fs=1&rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="853" height="505"></embed></object>


### Project Particulars

At the moment there are clients for both Mac and Windows platforms. At the moment this repository should be considered very unstable but over the next few weeks the master branch should converge to a stable point.

Relay uses the HandOff library for describing and communicating information about tasks. The plan is to develop the HandOff library into a component that can be included in any iPad application so that application can send and receive tasks to and from the HandOff powered Relay client running on a computer. The HandOff library depends on Jens Alfke's [MYNetwork](http://bitbucket.org/snej/mynetwork/wiki/Home) library for network communication. That library implements a lightweight, BEEP like protocol called [BLIP](http://bitbucket.org/snej/mynetwork/wiki/BLIP/Overview).

This project was started at the [iPadDevCamp](http://www.iphonedevcamp.org/) 2010 Hackathon. It was created by team Double Gravity, a collaboration of engineers from two companies: [doubleTwist](http://www.doubletwist.com/) and [Gravity Mobile](http://www.gravitymobile.com/).