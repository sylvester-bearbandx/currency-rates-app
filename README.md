# Currency Rates

This is a simple and lightweight iOS app that shows real-time currency exchange rates. You can browse current rates, mark your favorite currencies, and still use the app even without an internet connection.

## What the App Can Do

- Shows a list of exchange rates using a GraphQL API
- Lets you add or remove favorite currencies
- Works in offline mode with cached data
- Refreshes automatically every 60 seconds
- Supports manual refresh with pull-to-refresh
- Displays the last update time
- Two tabs: All currencies and Favorites
- Nice star animation when toggling favorites

## Tech Used

- Swift & UIKit
- MVVM architecture
- UICollectionView with Compositional Layout
- Diffable Data Source
- Auto Layout (all in code, no storyboards)
- GraphQL networking (SWOP API)
- Data saved with UserDefaults
- Unit tests with XCTest

## Project Structure

This project follows MVVM for a clear separation between logic and UI.

- `ViewModel` handles logic and state
- `ViewController` is UI-only
- Favorites and cached rates are saved in UserDefaults
- UI is built fully in code using compositional layouts and diffable data source


## API Info

The app uses a GraphQL API for currency exchange rates.

Sample query used in the app:

```graphql
{
  latest {
    baseCurrency
    quoteCurrency
    quote
    date
  }
}
```

## How Offline Mode Works

If there's no internet connection, the app will automatically load the latest saved exchange rates and favorites from cache. So you can still use it on the go, even when offline.

It saves:
- The last loaded exchange rates
- Your list of favorites
- The time of the last successful update

This data is stored using `UserDefaults`. A red banner appears when you're offline, along with the last update date. Once the network is back, the data updates every minute or via pull-to-refresh.

## Improvements for the Future

- Add a search field to filter currencies
- Migrate caching from UserDefaults to CoreData or Realm
- Expand unit test coverage, possibly add UI/integration tests

## Testing

Unit tests are included to verify the core functionality of the app. Tests cover:

- ViewModel logic (adding and removing favorites, loading cached data)
- Persistence (storing and retrieving cached rates and favorites)
- Offline mode behavior.

Tests use XCTest and can be found in the CurrencyRatesAppTests folder.
