# Fetch-RecipeBrowser

Several features for this project:

Project has several notes/documentation spots within it. Search for a triple slash "///" and you will find them.

1. Scroll horizontally to view various recipes in the Grid.
2. Tap the heart icon on any recipe to favorite it. If you exit the app, it will save your favorites.
3. To view only favorites or all recipes, toggle the switch in the top left.
4. Details for each recipe contain a scrollable list of ingredients, and a scrollable view of instructions.
5. The details screen only requires an API fetch once per session; once you have visited the details for a particular recipe,
   the data is cached for that session and you can revisit without an additional API call.
7. A very simple unit testing suite is included in the project for all networking done.
8. Along with the above, XCode Cloud integration is enabled with a quick and simple workflow. Any time changes
    are made to the develop branch in GitHub or pull requests against it are created, the testing suite is run.
9. The Activity Indicator on the Loader that appears while waiting for API calls to complete is just a UIActivityIndicator that is being used in SwiftUI via a UIViewRepresentable.
10. There is a 3 second timeout interval on the API requests. A basic retry logic popup will prompt the user to try reloading the recipes/recipe details. Note that this is for any individual request, not the whole block. Also did not add this for the image requests.
11. Users can search for recipes within different categories by selecting the category name in the top right and selecting a new one.
12. Users can search within a category or within favorites that have been loaded, using the search bar, for a recipe name.
** Note that favorites that have not been loaded are not currently saved to disk. Therefore, you will only see favorites from categories you have already looked at on the current session. This is only a problem well outside the scope of this challenge, however (when you have favorites from multiple categories).**
13. A notes section can be accessed and used for any recipe by swiping the tab view on the "Instructions" panel, for any changes a user might want to make to the recipe.
14. Users can tap the "watch on YouTube" link or the "View article" link, on the bottom of the recipe details screen to navigate to the video/article.

Happy testing! Please let me know if you have any questions, I will be happy to answer them.
 
