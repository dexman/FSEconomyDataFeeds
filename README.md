# FSEconomyDataFeeds

Client for accessing FSEconomy feeds from Swift.

## Usage

```
import FSEconomyDataFeeds
let client = FeedClient(userKey: "ABC…")
let response = client.request(Feeds.ICAOJobsFeed(.to, icaos: "KDFW"))
…
```

## Available Feeds

All of the available feeds are nested under the `Feeds` enum.
