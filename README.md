# LastFMKit

A comprehensive Swift SDK for the Last.fm API, designed with protocol-oriented programming and modern Swift features.

## Features

- ✅ Complete coverage of Last.fm API endpoints through Cloudflare proxy
- ✅ Secure authentication with credentials managed by Cloudflare Worker
- ✅ Protocol-oriented architecture with clean separation of concerns
- ✅ Async/await support throughout
- ✅ Cross-platform support (macOS, iOS, tvOS, watchOS, Linux)
- ✅ Strongly-typed models with Codable
- ✅ Configurable retry policies and timeout handling
- ✅ Comprehensive error handling
- ✅ Built-in CLI tool for testing all endpoints

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/LastFMKit", from: "1.0.0")
]
```

## Quick Start

```swift
import LastFMKit

// Create a client with default configuration
let client = LastFMClient()

// Or customize the configuration
let client = LastFMClient(
    baseURL: "https://lastfm-proxy-worker.guitaripod.workers.dev",
    timeout: 30,
    retryPolicy: .exponentialBackoff(maxRetries: 3)
)
```

## Authentication

LastFMKit supports Last.fm authentication for accessing user-specific endpoints:

```swift
// The authentication flow is handled through the Cloudflare Worker
// which manages all API credentials securely

// 1. Get auth URL from the worker
let authURL = try await client.auth.getAuthURL()

// 2. Direct user to auth URL (opens in browser)
// User authorizes and receives a token

// 3. Exchange token for session
let session = try await client.auth.getSession(token: userToken)

// 4. Use authenticated endpoints
let myInfo = try await client.user.getInfo(sessionKey: session.key)
```

## Usage Examples

### Artist Methods

```swift
// Search for artists
let (artists, pagination) = try await client.artist.search(artist: "Radiohead", limit: 10)

// Get artist info
let artist = try await client.artist.getInfo(artist: "Radiohead")

// Get top tracks
let (tracks, _) = try await client.artist.getTopTracks(artist: "Radiohead", limit: 20)

// Get similar artists
let similarArtists = try await client.artist.getSimilar(artist: "Radiohead", limit: 10)

// Get artist correction
if let correction = try await client.artist.getCorrection(artist: "Radioheed") {
    print("Did you mean: \(correction.name)?")
}
```

### Album Methods

```swift
// Search for albums
let (albums, pagination) = try await client.album.search(album: "OK Computer")

// Get album info with tracks
let album = try await client.album.getInfo(artist: "Radiohead", album: "OK Computer")

// Get album tags
let tags = try await client.album.getTopTags(artist: "Radiohead", album: "OK Computer")
```

### Track Methods

```swift
// Search for tracks
let (tracks, pagination) = try await client.track.search(track: "Creep")

// Get track info
let track = try await client.track.getInfo(artist: "Radiohead", track: "Creep")

// Get similar tracks
let similar = try await client.track.getSimilar(artist: "Radiohead", track: "Creep", limit: 10)
```

### User Methods

```swift
// Get user info
let user = try await client.user.getInfo(user: "rj")

// Get recent tracks
let (recentTracks, _) = try await client.user.getRecentTracks(user: "rj", limit: 50)

// Get top artists for a time period
let (topArtists, _) = try await client.user.getTopArtists(
    user: "rj", 
    period: .oneMonth, 
    limit: 10
)

// Get loved tracks
let (lovedTracks, _) = try await client.user.getLovedTracks(user: "rj")
```

### Chart Methods

```swift
// Get top artists globally
let (topArtists, pagination) = try await client.chart.getTopArtists(limit: 10)

// Get top tracks
let (topTracks, _) = try await client.chart.getTopTracks(limit: 10)

// Get top tags
let (topTags, _) = try await client.chart.getTopTags()
```

### Geographic Methods

```swift
// Get top artists by country
let (artists, _) = try await client.geo.getTopArtists(country: "United States", limit: 10)

// Get top tracks by country
let (tracks, _) = try await client.geo.getTopTracks(country: "United Kingdom", limit: 10)
```

### Tag Methods

```swift
// Get tag info
let tagInfo = try await client.tag.getInfo(tag: "rock")

// Get top artists for a tag
let (artists, _) = try await client.tag.getTopArtists(tag: "indie", limit: 20)

// Get similar tags
let similarTags = try await client.tag.getSimilar(tag: "electronic")
```

## Error Handling

LastFMKit provides comprehensive error handling:

```swift
do {
    let artist = try await client.artist.getInfo(artist: "Unknown Artist")
} catch let error as LastFMError {
    switch error {
    case .invalidParameters(let message):
        print("Invalid parameters: \(message)")
    case .networkError(let underlyingError):
        print("Network error: \(underlyingError)")
    case .decodingError:
        print("Failed to decode response")
    case .rateLimitExceeded:
        print("Rate limit exceeded, please try again later")
    case .apiError(let code, let message):
        print("API error \(code): \(message)")
    default:
        print("Error: \(error.localizedDescription)")
    }
}
```

## CLI Tool

LastFMKit includes a comprehensive CLI tool for testing all endpoints:

```bash
# Build the CLI tool
swift build

# Authentication
.build/debug/lastfm-cli auth login
.build/debug/lastfm-cli auth status
.build/debug/lastfm-cli auth logout

# Search for artists
.build/debug/lastfm-cli artist search "The Beatles" --limit 5

# Get artist info
.build/debug/lastfm-cli artist info "Radiohead"

# Get user's recent tracks
.build/debug/lastfm-cli user recent-tracks "rj" --limit 10

# Get top artists chart
.build/debug/lastfm-cli chart top-artists --limit 10

# Authenticated user commands
.build/debug/lastfm-cli my info
.build/debug/lastfm-cli my recent-tracks --limit 10
.build/debug/lastfm-cli my top-artists --period 7day

# Get help
.build/debug/lastfm-cli --help
```

For a complete list of all available commands and their options, see the [CLI Manual](CLI_MANUAL.md).

## Configuration

### Custom Base URL

```swift
let client = LastFMClient(baseURL: "https://your-custom-proxy.com")
```

### Timeout Configuration

```swift
let client = LastFMClient(timeout: 60) // 60 seconds
```

### Retry Policies

```swift
// No retries
let client = LastFMClient(retryPolicy: .none)

// Fixed delay retries
let client = LastFMClient(retryPolicy: .fixed(maxRetries: 3, delay: 2.0))

// Exponential backoff (default)
let client = LastFMClient(retryPolicy: .exponentialBackoff(maxRetries: 3, initialDelay: 1.0))
```

## Requirements

- Swift 5.9+
- macOS 13.0+ / iOS 16.0+ / tvOS 16.0+ / watchOS 9.0+ / Linux

## Architecture

LastFMKit follows a protocol-oriented architecture:

- **NetworkClient**: Handles all HTTP requests with retry logic and error handling
- **BaseAPI**: Base class for all API categories
- **Strongly-typed models**: All responses are decoded into type-safe Swift structs
- **Async/await**: Modern concurrency throughout the SDK

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

LastFMKit is available under the MIT license. See the LICENSE file for more info.

## Author

Marcus Ziadé - [@marcusziade](https://github.com/marcusziade)