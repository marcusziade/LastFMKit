# LastFMKit CLI Authentication Guide

## Overview

The LastFMKit CLI uses a secure authentication flow where API credentials are managed by the Cloudflare Worker proxy, not the CLI itself.

## How It Works

### Public Commands (No Auth Required)
Most commands work without any API key configuration:
```bash
lastfm-cli artist info "The Beatles"
lastfm-cli album search "Dark Side"
lastfm-cli user recent-tracks "username"
```

The Cloudflare Worker automatically adds the API key to these requests.

### Authenticated Commands (Auth Required)
For personal data access, you need to authenticate:

1. **Initial Setup** - You need an API key ONLY for generating the auth URL:
   ```bash
   # Set your API key (one time only)
   lastfm-cli config set apiKey YOUR_API_KEY
   
   # Or initialize config with API key
   lastfm-cli config init --api-key YOUR_API_KEY
   ```
   
   Get an API key from: https://www.last.fm/api/account/create

2. **Login** - Authenticate with Last.fm:
   ```bash
   lastfm-cli auth login
   ```
   
   This will:
   - Open your browser to Last.fm's authorization page
   - After you authorize, you'll be redirected to a local callback page
   - Copy the token from the callback page
   - Paste it into the CLI when prompted
   - The CLI sends this token to the Worker
   - The Worker exchanges it for a session key using its stored API secret
   - The session key is saved locally in `~/.config/lastfm-cli/config.json`

3. **Use Authenticated Commands**:
   ```bash
   lastfm-cli my info
   lastfm-cli my recent-tracks
   lastfm-cli my top-artists --period 7day
   ```

4. **Check Auth Status**:
   ```bash
   lastfm-cli auth status
   ```

5. **Logout**:
   ```bash
   lastfm-cli auth logout
   ```

## Security Model

```
┌─────────┐         ┌──────────────────┐         ┌──────────────┐
│   CLI   │ ──────> │ Cloudflare Worker│ ──────> │ Last.fm API  │
└─────────┘         └──────────────────┘         └──────────────┘
     │                       │                            
     │                       └── Has API key & secret     
     └── Only stores             in environment vars      
         - API key (for auth URL)                        
         - Session key (after auth)                      
```

- **API Key**: Only needed locally to generate the auth URL
- **API Secret**: Never leaves the Cloudflare Worker
- **Session Key**: Stored locally after successful auth
- **Request Signing**: All handled by the Worker

This design ensures that sensitive API credentials are never exposed in client code or git repositories.

## Configuration

The CLI configuration is stored at `~/.config/lastfm-cli/config.json`:

```json
{
  "workerURL": "https://lastfm-proxy-worker.guitaripod.workers.dev",
  "apiKey": "your_api_key_here",
  "outputFormat": "pretty",
  "auth": {
    "username": "your_username",
    "sessionKey": "your_session_key"
  }
}
```

## Troubleshooting

### "No API key configured" error
You need to set an API key before using authentication:
```bash
lastfm-cli config set apiKey YOUR_API_KEY
```

### "Not authenticated" error
You need to login first:
```bash
lastfm-cli auth login
```

### Browser doesn't open
Copy the URL printed in the terminal and open it manually in your browser.

### Can't find the token
After authorizing in the browser, you'll be redirected to a page showing the token. If the redirect fails, check the URL - the token is in the `token=` parameter.