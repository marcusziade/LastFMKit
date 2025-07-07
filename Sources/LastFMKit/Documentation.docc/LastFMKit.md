# ``LastFMKit``

A comprehensive Swift SDK for the Last.fm API with full async/await support and cross-platform compatibility.

## Overview

LastFMKit provides a modern, type-safe interface to the Last.fm API, allowing you to easily integrate music metadata, user statistics, and scrobbling functionality into your Swift applications.

The SDK is designed with Swift best practices in mind, featuring:
- Full async/await support for all API calls
- Comprehensive error handling with typed errors
- Automatic retry policies with exponential backoff
- Cross-platform support (iOS, macOS, tvOS, watchOS, Linux)
- Zero external dependencies beyond Swift's standard library

## Getting Started

### Installation

Add LastFMKit to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/LastFMKit", from: "1.0.0")
]
```

### Basic Usage

Create a client and start making API calls:

```swift
import LastFMKit

// Initialize the client
let client = LastFMClient()

// Search for an artist
let (artists, _) = try await client.artist.search(artist: "Radiohead", limit: 10)

// Get user's recent tracks
let (tracks, _) = try await client.user.getRecentTracks("username", limit: 50)
```

### Configuration

Customize the client behavior with `ClientConfiguration`:

```swift
let config = ClientConfiguration(
    baseURL: "https://custom-proxy.example.com",
    timeout: 60,
    retryPolicy: .exponentialBackoff(maxRetries: 5)
)
let client = LastFMClient(configuration: config)
```

## Topics

### Essentials

- ``LastFMClient``
- ``ClientConfiguration``
- ``LastFMError``

### API Categories

- ``ArtistAPI``
- ``AlbumAPI``
- ``TrackAPI``
- ``UserAPI``
- ``ChartAPI``
- ``GeoAPI``
- ``TagAPI``
- ``LibraryAPI``
- ``AuthAPI``

### Core Models

- ``Artist``
- ``Album``
- ``Track``
- ``User``
- ``Tag``

### Common Types

- ``PaginationAttributes``
- ``Period``
- ``Image``
- ``Date``

## Authentication

For endpoints that require authentication, you'll need to provide API credentials. The SDK uses a proxy server by default that handles API key management securely.

## Error Handling

All API methods throw ``LastFMError`` which provides detailed error information:

```swift
do {
    let artist = try await client.artist.getInfo(artist: "Unknown Artist")
} catch let error as LastFMError {
    switch error {
    case .notFound:
        print("Artist not found")
    case .rateLimitExceeded:
        print("Too many requests, please wait")
    case .networkError(let underlying):
        print("Network error: \(underlying)")
    default:
        print("Error: \(error.localizedDescription)")
    }
}
```

## Rate Limiting

The SDK automatically handles rate limiting with built-in retry logic. When rate limits are exceeded, requests will be retried with exponential backoff by default.

## Thread Safety

All types in LastFMKit are thread-safe and can be used from multiple concurrent contexts. The ``LastFMClient`` instance can be shared across your entire application.

## Command Line Interface

LastFMKit also includes a powerful CLI tool for exploring the Last.fm API from your terminal:

```bash
# Search for artists
lastfm artist search "The Beatles"

# Get user's recent tracks
lastfm user recent-tracks "rj" --limit 10

# Get top artists by country
lastfm geo top-artists "Sweden" --limit 5
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/marcusziade/LastFMKit/blob/main/CONTRIBUTING.md) for details.

## License

LastFMKit is available under the MIT license. See the [LICENSE](https://github.com/marcusziade/LastFMKit/blob/main/LICENSE) file for details.