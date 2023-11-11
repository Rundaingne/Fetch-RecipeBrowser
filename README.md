# Fetch-RecipeBrowser

Several features for this project:

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
10. There is a 5 second timeout interval on the API requests. A basic retry logic popup will prompt the user to try reloading the recipes/recipe details. 

Happy testing! Please let me know if you have any questions, I will be happy to answer them.
 
