RottenTomatoes
==============

A Simple IOS app for Rotten Tomatoes Movie Listing Box office and Top DVD.

Total Time Spent : 8 hrs

User Story completed:

1. User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
2. User can view movie details by tapping on a cell 
3. User sees loading state while waiting for movies API. I am using MBProgressHUD for this.
4. User sees error message when there's a networking error.
5. User can pull to refresh the movie list.
6. All images fade in (optional)
7. All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional).
8. Add a tab bar for Box Office and DVD. (optional)
9. Customize the highlight and selection effect of the cell. (optional)
10.Customize the navigation bar. (optional)
11. Add a search bar. (optional)

# Installation
1. Clone the project
2. Install dependencies using CocoaPods

  `` pod install ``

Walkthrough
=============
![Video Walkthrough](https://raw.githubusercontent.com/pravinneema/RottenTomatoes/master/Demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

# Libraries Used
1. [AFNetworking](http://afnetworking.com/)
2. [MBProgressHUD](https://github.com/mutualmobile/MMProgressHUD)
