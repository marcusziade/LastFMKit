# Getting Started with LastFMKit

Learn how to integrate LastFMKit into your Swift project and make your first API calls.

## Overview

This guide will walk you through the process of adding LastFMKit to your project, configuring the client, and making various API calls to retrieve music data.

## Installation

### Swift Package Manager

Add LastFMKit to your `Package.swift` file:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/marcusziade/LastFMKit", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["LastFMKit"]
        )
    ]
)
```

### Xcode

1. Open your project in Xcode
2. Go to File → Add Package Dependencies
3. Enter the repository URL: `https://github.com/marcusziade/LastFMKit`
4. Click Add Package

## Creating Your First Client

The simplest way to get started is to create a client with default settings:

```swift
import LastFMKit

let client = LastFMClient()
```

### Custom Configuration

For production apps, you might want to customize the timeout and retry behavior:

```swift
let config = ClientConfiguration(
    timeout: 60, // 60 seconds
    retryPolicy: .exponentialBackoff(maxRetries: 5)
)

let client = LastFMClient(configuration: config)
```

## Making API Calls

All API calls in LastFMKit are asynchronous and use Swift's async/await syntax.

### Searching for Artists

```swift
do {
    let (artists, pagination) = try await client.artist.search(
        artist: "The Beatles",
        limit: 10
    )
    
    print("Found \(pagination.total) total results")
    
    for artist in artists {
        print("\(artist.name) - \(artist.listeners ?? "0") listeners")
    }
} catch {
    print("Search failed: \(error)")
}
```

### Getting Artist Information

```swift
do {
    let artist = try await client.artist.getInfo(
        artist: "Radiohead",
        autocorrect: true
    )
    
    if let bio = artist.bio?.summary {
        print("Biography: \(bio)")
    }
    
    if let stats = artist.stats {
        print("Listeners: \(stats.listeners)")
        print("Playcount: \(stats.playcount)")
    }
} catch {
    print("Failed to get artist info: \(error)")
}
```

### Finding Similar Artists

```swift
do {
    let similar = try await client.artist.getSimilar(
        artist: "Portishead",
        limit: 5
    )
    
    print("Artists similar to Portishead:")
    for artist in similar {
        if let match = artist.match {
            print("- \(artist.name) (Match: \(match)%)")
        }
    }
} catch {
    print("Failed to find similar artists: \(error)")
}
```

### Getting User's Recent Tracks

```swift
do {
    let (tracks, pagination) = try await client.user.getRecentTracks(
        "lastfm_username",
        limit: 20
    )
    
    for track in tracks {
        let timestamp = track.date?.uts ?? "Now playing"
        print("\(track.name) by \(track.artist.name) - \(timestamp)")
    }
} catch {
    print("Failed to get recent tracks: \(error)")
}
```

### Working with Charts

```swift
do {
    // Get top artists globally
    let (topArtists, _) = try await client.chart.getTopArtists(limit: 10)
    
    print("Top 10 Artists Worldwide:")
    for (index, artist) in topArtists.enumerated() {
        print("\(index + 1). \(artist.name)")
    }
    
    // Get top tracks globally
    let (topTracks, _) = try await client.chart.getTopTracks(limit: 10)
    
    print("\nTop 10 Tracks Worldwide:")
    for (index, track) in topTracks.enumerated() {
        print("\(index + 1). \(track.name) by \(track.artist.name)")
    }
} catch {
    print("Failed to get charts: \(error)")
}
```

### Geographic Data

```swift
do {
    // Get top artists in a specific country
    let (artists, _) = try await client.geo.getTopArtists(
        country: "Japan",
        limit: 5
    )
    
    print("Top Artists in Japan:")
    for artist in artists {
        print("- \(artist.name)")
    }
} catch {
    print("Failed to get geo data: \(error)")
}
```

## Error Handling

LastFMKit provides detailed error information through the `LastFMError` enum:

```swift
do {
    let artist = try await client.artist.getInfo(artist: "Unknown Artist XYZ")
} catch let error as LastFMError {
    switch error {
    case .invalidParameters(let message):
        print("Invalid parameters: \(message)")
        
    case .networkError(let underlying):
        print("Network error: \(underlying.localizedDescription)")
        
    case .rateLimitExceeded:
        print("Rate limit exceeded. Please wait before retrying.")
        
    case .apiError(let code, let message):
        if code == 6 {
            print("Artist not found: \(message)")
        } else {
            print("API error \(code): \(message)")
        }
        
    default:
        print("Error: \(error.localizedDescription)")
    }
} catch {
    print("Unexpected error: \(error)")
}
```

## Pagination

Many endpoints return paginated results. Here's how to work with pagination:

```swift
func getAllUserTracks(username: String) async throws -> [Track] {
    var allTracks: [Track] = []
    var currentPage = 1
    var hasMorePages = true
    
    while hasMorePages {
        let (tracks, pagination) = try await client.user.getRecentTracks(
            username,
            page: currentPage,
            limit: 200 // Maximum allowed
        )
        
        allTracks.append(contentsOf: tracks)
        
        currentPage += 1
        hasMorePages = currentPage <= pagination.totalPages
        
        // Add a small delay to be respectful of rate limits
        if hasMorePages {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }
    
    return allTracks
}
```

## Best Practices

### 1. Reuse Client Instances

Create a single `LastFMClient` instance and reuse it throughout your app:

```swift
// In your app's initialization
class MusicService {
    static let shared = MusicService()
    let client = LastFMClient()
    
    private init() {}
}
```

### 2. Handle Rate Limits

The SDK automatically retries requests with exponential backoff, but you should still handle rate limit errors gracefully:

```swift
func searchWithRateLimit(query: String) async throws -> [Artist] {
    do {
        let (artists, _) = try await client.artist.search(artist: query)
        return artists
    } catch LastFMError.rateLimitExceeded {
        // Wait longer before retrying
        try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
        return try await searchWithRateLimit(query: query)
    }
}
```

### 3. Use Autocorrect

Enable autocorrect for user-provided input to handle typos:

```swift
let artist = try await client.artist.getInfo(
    artist: userInput,
    autocorrect: true
)
```

### 4. Cache Results

Consider caching frequently accessed data to reduce API calls:

```swift
actor ArtistCache {
    private var cache: [String: Artist] = [:]
    
    func getArtist(name: String, client: LastFMClient) async throws -> Artist {
        if let cached = cache[name.lowercased()] {
            return cached
        }
        
        let artist = try await client.artist.getInfo(artist: name)
        cache[name.lowercased()] = artist
        return artist
    }
}
```

## Next Steps

- Explore the ``LastFMClient`` documentation for all available endpoints
- Check out specific API documentation for detailed parameter information
- Read about ``LastFMError`` for comprehensive error handling
- Try the command-line interface for quick API exploration