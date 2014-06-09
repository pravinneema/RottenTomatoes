RottenTomatoes
==============

Rotten Tomatoes Movie Listing

Run- pod install to download AFNetworking and 3rd party control.

I am able to do following tasks:
1 .User can view a list of movies from Rotten Tomatoes.  
2. Poster images must be loading asynchronously.
3. User can view movie details by tapping on a cell (but UI is not good)
4. User sees loading state while waiting for movies API. I am using MBProgressHUD for this.
5. User sees error message when there's a networking error.  You may not use UIAlertView to display the error.  See this screenshot for what the error message should look like: network error screenshot.
6. User can pull to refresh the movie list.
7. All images fade in 
8. I am not able to put footer bar for movie and dvd.

Issue:
I am not sure I am using correct way to show detail view.
When I refresh page then images are miss position.
On detail page page is also moving with scroll and not able to provide scroll on synopsis.
Didn't put back button on head on detail view.

