# LastFMKit CLI Manual

A comprehensive guide to all available commands in the LastFMKit CLI tool with actual command outputs.

## Table of Contents

- [Authentication](#authentication)
- [Artist Commands](#artist-commands)
- [Album Commands](#album-commands)
- [Track Commands](#track-commands)
- [Chart Commands](#chart-commands)
- [Geo Commands](#geo-commands)
- [Tag Commands](#tag-commands)
- [User Commands](#user-commands)
- [Library Commands](#library-commands)
- [My Commands (Authenticated)](#my-commands-authenticated)

---

## Authentication

<details>
<summary><strong>Auth Commands</strong> - Login, logout, and manage authentication</summary>

### auth login

Authenticate with Last.fm through the browser flow.

**Command:**
```bash
lastfm-cli auth login
```

**Output:**
```
Opening browser for authorization...
If the browser doesn't open, visit this URL:
https://www.last.fm/api/auth/?api_key=e4b41043bb3fc9fb1aceeea95a435ad8&cb=http://localhost:41419/auth/callback

After authorizing, you'll be redirected to a page showing an auth token.
Please enter the token here:

Token: [user enters token]

✓ Successfully authenticated as 'username'
```

### auth status

Check current authentication status.

**Command:**
```bash
lastfm-cli auth status
```

**Output:**
```
Authenticated: Yes
Username: guitaripod
```

### auth get-session

Get a session key from a token.

**Command:**
```bash
lastfm-cli auth get-session "token_value"
```

**Output (with invalid token):**
```
Failed to get session: API error 4: Unauthorized Token - This token has not been issued
```

### auth mobile-session

Get a mobile session with username and password.

**Command:**
```bash
lastfm-cli auth mobile-session "username" "password"
```

**Output (failed):**
```
Failed to get mobile session: API error 4: You must use POST method for this request
```

### auth logout

Log out and clear session.

**Command:**
```bash
lastfm-cli auth logout
```

**Output:**
```
Successfully logged out
```

</details>

---

## Artist Commands

<details>
<summary><strong>Artist Commands</strong> - Search, get info, top tracks/albums, and similar artists</summary>

### artist info

Get detailed information about an artist.

**Command:**
```bash
lastfm-cli artist info "Taylor Swift"
```

**Output:**
```
Artist: Taylor Swift
URL: https://www.last.fm/music/Taylor+Swift

Biography:
Taylor Alison Swift (born December 13, 1989) is an American singer-songwriter. Recognized for her genre-spanning discography, songwriting, and artistic reinventions, Swift is a prominent cultural figure who has been cited as an influence on a generation of music artists.

Swift began professional songwriting at age 14 and moved from her native West Reading, Pennsylvania to Nashville, Tennessee in 2005 to pursue a career as a country singer. She signed a recording contract <a href="https://www.last.fm/music/Taylor+Swift">Read more on Last.fm</a>

Top Tags:
  - pop
  - country
  - female vocalists
  - acoustic
  - singer-songwriter
```

**With autocorrect:**
```bash
lastfm-cli artist info "The Beatles" --autocorrect true
```

### artist similar

Get similar artists.

**Command:**
```bash
lastfm-cli artist similar "Radiohead"
```

**Output:**
```
Similar Artists to Radiohead:

1. Thom Yorke
   URL: https://www.last.fm/music/Thom+Yorke

2. Atoms for Peace
   URL: https://www.last.fm/music/Atoms+for+Peace

3. Blur
   URL: https://www.last.fm/music/Blur

4. Arcade Fire
   URL: https://www.last.fm/music/Arcade+Fire

5. The Smile
   URL: https://www.last.fm/music/The+Smile

6. Muse
   URL: https://www.last.fm/music/Muse

7. Pixies
   URL: https://www.last.fm/music/Pixies

8. Portishead
   URL: https://www.last.fm/music/Portishead

9. R.E.M.
   URL: https://www.last.fm/music/R.E.M.

10. Björk
   URL: https://www.last.fm/music/Bj%C3%B6rk
```

### artist search

Search for artists.

**Command:**
```bash
lastfm-cli artist search "Swift" --limit 5
```

**Output:**
```
Search Results for 'Swift':
Total Results: 40993
Page 1 of 8199

1. Taylor Swift
   Listeners: 5316650
   URL: https://www.last.fm/music/Taylor+Swift

2. SWiFT
   Listeners: 1227
   URL: https://www.last.fm/music/SWiFT

3. P.T.O. Swift
   Listeners: 1122
   URL: https://www.last.fm/music/P.T.O.+Swift

4. SWift
   Listeners: 3006
   URL: https://www.last.fm/music/SWift

5. MaGeStiK_1 feat. P.T.O. Swift
   Listeners: 2
   URL: https://www.last.fm/music/MaGeStiK_1+feat.+P.T.O.+Swift
```

### artist top-albums

Get top albums for an artist.

**Command:**
```bash
lastfm-cli artist top-albums "Kanye West" --limit 10
```

**Output:**
```
Top Albums by Kanye West:

1. My Beautiful Dark Twisted Fantasy
   Playcount: 57810370

2. Graduation
   Playcount: 57641033

3. The College Dropout
   Playcount: 42456606

4. Late Registration
   Playcount: 40303439

5. 808s & Heartbreak
   Playcount: 31741328

6. Yeezus
   Playcount: 29298134

7. The Life of Pablo
   Playcount: 18854957

8. Cruel Summer
   Playcount: 15959490

9. ye
   Playcount: 11322949

10. Watch the Throne
    Playcount: 10999606
```

### artist top-tracks

Get top tracks for an artist.

**Command:**
```bash
lastfm-cli artist top-tracks "Taylor Swift" --limit 10
```

**Output:**
```
Top Tracks by Taylor Swift:

1. Blank Space
   Playcount: 6875522
   Listeners: 885491

2. Style
   Playcount: 5090830
   Listeners: 693444

3. Shake It Off
   Playcount: 4752296
   Listeners: 741976

4. Anti-Hero
   Playcount: 4379516
   Listeners: 1204956

5. Lover
   Playcount: 4317652
   Listeners: 729745

6. Love Story
   Playcount: 4292846
   Listeners: 755327

7. Wildest Dreams
   Playcount: 4180313
   Listeners: 648296

8. I Knew You Were Trouble.
   Playcount: 3957635
   Listeners: 738318

9. Delicate
   Playcount: 3798459
   Listeners: 603282

10. You Belong With Me
    Playcount: 3617534
    Listeners: 682436
```

</details>

---

## Album Commands

<details>
<summary><strong>Album Commands</strong> - Search albums and get album information</summary>

### album info

Get detailed information about an album.

**Command:**
```bash
lastfm-cli album info "Taylor Swift" "folklore"
```

**Output:**
```
Album: folklore
Artist: Taylor Swift
URL: https://www.last.fm/music/Taylor+Swift/folklore

Listeners: 1742096
Playcount: 217602753

Tags:
  - folk
  - dream pop
  - indie pop
  - folk pop
  - chamber pop

Tracks:
1. the 1 (3:30)
2. cardigan (3:59)
3. the last great american dynasty (3:51)
4. exile (4:45)
5. my tears ricochet (4:15)
6. mirrorball (3:28)
7. seven (3:28)
8. august (4:21)
9. this is me trying (3:15)
10. illicit affairs (3:10)
11. invisible string (4:12)
12. mad woman (3:57)
13. epiphany (4:49)
14. betty (4:54)
15. peace (3:54)
16. hoax (3:40)
17. the lakes (bonus track) (3:31)
```

### album search

Search for albums.

**Command:**
```bash
lastfm-cli album search "Abbey Road" --limit 5
```

**Output:**
```
Search Results for 'Abbey Road':
Total Results: 26492
Page 1 of 5299

1. Abbey Road by The Beatles
   URL: https://www.last.fm/music/The+Beatles/Abbey+Road

2. Abbey Road (Remastered) by The Beatles
   URL: https://www.last.fm/music/The+Beatles/Abbey+Road+(Remastered)

3. Abbey Road (Super Deluxe Edition) by The Beatles
   URL: https://www.last.fm/music/The+Beatles/Abbey+Road+(Super+Deluxe+Edition)

4. Abbey Road Sessions by Kylie Minogue
   URL: https://www.last.fm/music/Kylie+Minogue/Abbey+Road+Sessions

5. Return To Abbey Road by Steve Hackett
   URL: https://www.last.fm/music/Steve+Hackett/Return+To+Abbey+Road
```

</details>

---

## Track Commands

<details>
<summary><strong>Track Commands</strong> - Search tracks, get track info, and find similar tracks</summary>

### track info

Get detailed information about a track.

**Command:**
```bash
lastfm-cli track info "Queen" "Bohemian Rhapsody"
```

**Output:**
```
Track: Bohemian Rhapsody
Artist: Queen
Album: A Night at the Opera
Duration: 5:58

Listeners: 2005848
Playcount: 13948654

Tags:
  - classic rock
  - rock
  - Queen
  - 70s
  - 80s

URL: https://www.last.fm/music/Queen/_/Bohemian+Rhapsody
```

### track similar

Get similar tracks.

**Command:**
```bash
lastfm-cli track similar "Radiohead" "Creep" --limit 10
```

**Output:**
```
Similar Tracks to Creep by Radiohead:

1. No Surprises by Radiohead
   Playcount: 41987728

2. Karma Police by Radiohead
   Playcount: 33681945

3. Everlong by Foo Fighters
   Playcount: 36586364

4. Mr. Brightside by The Killers
   Playcount: 43453700

5. Under the Bridge by Red Hot Chili Peppers
   Playcount: 23754267

6. Black by Pearl Jam
   Playcount: 23222251

7. Wonderwall by Oasis
   Playcount: 45532223

8. Paranoid Android by Radiohead
   Playcount: 29088485

9. The Man Who Sold the World by Nirvana
   Playcount: 16537273

10. High and Dry by Radiohead
    Playcount: 21871651
```

### track search

Search for tracks.

**Command:**
```bash
lastfm-cli track search "Yesterday" --limit 5
```

**Output:**
```
Search Results for 'Yesterday':
Total Results: 308101
Page 1 of 61621

1. Yesterday by The Beatles
   Artist: The Beatles
   Listeners: 1551467
   URL: https://www.last.fm/music/The+Beatles/_/Yesterday

2. Yesterday by Atmosphere
   Artist: Atmosphere
   Listeners: 213970
   URL: https://www.last.fm/music/Atmosphere/_/Yesterday

3. Yesterday by Imagine Dragons
   Artist: Imagine Dragons
   Listeners: 239674
   URL: https://www.last.fm/music/Imagine+Dragons/_/Yesterday

4. Yesterday Once More by Carpenters
   Artist: Carpenters
   Listeners: 477651
   URL: https://www.last.fm/music/Carpenters/_/Yesterday+Once+More

5. Yesterday (Remastered 2009) by The Beatles
   Artist: The Beatles
   Listeners: 74084
   URL: https://www.last.fm/music/The+Beatles/_/Yesterday+(Remastered+2009)
```

</details>

---

## Chart Commands

<details>
<summary><strong>Chart Commands</strong> - Get global top artists, tracks, and tags</summary>

### chart top-artists

Get the top artists chart.

**Command:**
```bash
lastfm-cli chart top-artists --limit 10
```

**Output:**
```
Top Artists:
Page 1 of 623807

1. Kendrick Lamar
   Listeners: 4504184
   Playcount: 357833424

2. Tyler, the Creator
   Listeners: 4282988
   Playcount: 336848672

3. Mac Miller
   Listeners: 3641475
   Playcount: 259127244

4. $uicideboy$
   Listeners: 2638361
   Playcount: 318871605

5. Radiohead
   Listeners: 7272071
   Playcount: 1189227948

6. Playboi Carti
   Listeners: 2861147
   Playcount: 240596362

7. Kanye West
   Listeners: 7206799
   Playcount: 1097161176

8. Drake
   Listeners: 6107636
   Playcount: 547871074

9. The Weeknd
   Listeners: 4666986
   Playcount: 369668916

10. David Bowie
    Listeners: 4981197
    Playcount: 362687406
```

### chart top-tracks

Get the top tracks chart.

**Command:**
```bash
lastfm-cli chart top-tracks --limit 10
```

**Output:**
```
Top Tracks:
Page 1 of 4094296

1. Manchild by Sabrina Carpenter
   Listeners: 29268
   Playcount: 112498

2. Dimed Out by Tiffany Day
   Listeners: 1653
   Playcount: 9531

3. manalive by Takayan
   Listeners: 22072
   Playcount: 125537

4. ❖ by LOONA
   Listeners: 48651
   Playcount: 308908

5. APT. by ROSÉ & Bruno Mars
   Listeners: 366125
   Playcount: 2596515

6. S/R (What Goes Around) by Mannequin Pussy
   Listeners: 29719
   Playcount: 141421

7. LOVE, MONEY, FAME by SEVENTEEN
   Listeners: 26303
   Playcount: 173513

8. Nice Guy by GRLwood
   Listeners: 22816
   Playcount: 130838

9. Thick Of It by KSI
   Listeners: 114033
   Playcount: 451695

10. Die With A Smile by Lady Gaga & Bruno Mars
    Listeners: 541021
    Playcount: 3568513
```

### chart top-tags

Get the top tags chart.

**Command:**
```bash
lastfm-cli chart top-tags --limit 10
```

**Output:**
```
Top Tags:
Page 1 of 286531

1. rock
   Reach: 402105

2. electronic
   Reach: 261281

3. alternative
   Reach: 259971

4. indie
   Reach: 259784

5. pop
   Reach: 232577

6. metal
   Reach: 176865

7. female vocalists
   Reach: 159521

8. alternative rock
   Reach: 154434

9. jazz
   Reach: 148313

10. Classic Rock
    Reach: 146762
```

</details>

---

## Geo Commands

<details>
<summary><strong>Geo Commands</strong> - Get top artists and tracks by country</summary>

### geo top-artists

Get top artists in a specific country.

**Command:**
```bash
lastfm-cli geo top-artists "United States" --limit 10
```

**Output:**
```
Top Artists in United States:
Page 1 of 303059

1. Radiohead
   Listeners: 7273071

2. David Bowie
   Listeners: 4981197

3. The Weeknd
   Listeners: 4668866

4. The Beatles
   Listeners: 5807807

5. Kanye West
   Listeners: 7206799

6. Drake
   Listeners: 6108297

7. Kendrick Lamar
   Listeners: 4505847

8. Fleetwood Mac
   Listeners: 4194466

9. Queen
   Listeners: 6417355

10. Daft Punk
    Listeners: 5647778
```

### geo top-tracks

Get top tracks in a specific country.

**Command:**
```bash
lastfm-cli geo top-tracks "Germany" --limit 10
```

**Output:**
```
Top Tracks in Germany:
Page 1 of 1934569

1. Smells Like Teen Spirit by Nirvana
   Listeners: 3605326

2. Africa by Toto
   Listeners: 1910057

3. Mr. Brightside by The Killers
   Listeners: 3438267

4. Come as You Are by Nirvana
   Listeners: 3259209

5. In the End by Linkin Park
   Listeners: 2723668

6. Seven Nation Army by The White Stripes
   Listeners: 2575918

7. Don't Stop Believin' by Journey
   Listeners: 1733225

8. Chop Suey! by System of a Down
   Listeners: 2714291

9. Take on Me by a-ha
   Listeners: 2475561

10. All I Want for Christmas Is You by Mariah Carey
    Listeners: 1956818
```

</details>

---

## Tag Commands

<details>
<summary><strong>Tag Commands</strong> - Get tag info and top artists/albums/tracks for tags</summary>

### tag info

Get information about a tag.

**Command:**
```bash
lastfm-cli tag info "rock"
```

**Output:**
```
Tag: rock
Reach: 402105

Description:
Rock music is a form of popular music with a prominent vocal melody, accompanied by guitar, drums, and bass. Many styles of rock music also use keyboard instruments such as organ, piano, mellotron, and synthesizers. Other instruments sometimes utilized in rock include saxophone, harmonica, violin, flute, French horn, banjo, melodica, and timpani. Also, less common stringed instruments such as mandolin and sitar are used. Rock music usually has a strong back beat <a href="http://www.last.fm/tag/rock">Read more on Last.fm</a>.
```

### tag top-artists

Get top artists for a tag.

**Command:**
```bash
lastfm-cli tag top-artists "pop" --limit 10
```

**Output:**
```
Top Artists for tag 'pop':

1. Ariana Grande
   URL: https://www.last.fm/music/Ariana+Grande

2. Billie Eilish
   URL: https://www.last.fm/music/Billie+Eilish

3. Lady Gaga
   URL: https://www.last.fm/music/Lady+Gaga

4. Katy Perry
   URL: https://www.last.fm/music/Katy+Perry

5. Madonna
   URL: https://www.last.fm/music/Madonna

6. Olivia Rodrigo
   URL: https://www.last.fm/music/Olivia+Rodrigo

7. Rihanna
   URL: https://www.last.fm/music/Rihanna

8. Elton John
   URL: https://www.last.fm/music/Elton+John

9. Bruno Mars
   URL: https://www.last.fm/music/Bruno+Mars

10. Michael Jackson
    URL: https://www.last.fm/music/Michael+Jackson
```

### tag top-albums

Get top albums for a tag.

**Command:**
```bash
lastfm-cli tag top-albums "jazz" --limit 10
```

**Output:**
```
Top Albums for tag 'jazz':

1. PERSONA5 ORIGINAL SOUNDTRACK by 目黒将司
   URL: https://www.last.fm/music/%E7%9B%AE%E9%BB%92%E5%B0%86%E5%8F%B8/PERSONA5+ORIGINAL+SOUNDTRACK

2. Chet Baker Sings by Chet Baker
   URL: https://www.last.fm/music/Chet+Baker/Chet+Baker+Sings

3. COWBOY BEBOP (Original Motion Picture Soundtrack) by 菅野よう子
   URL: https://www.last.fm/music/%E8%8F%85%E9%87%8E%E3%82%88%E3%81%86%E5%AD%90/COWBOY+BEBOP+(Original+Motion+Picture+Soundtrack)

4. Floral Shoppe by Macintosh Plus
   URL: https://www.last.fm/music/Macintosh+Plus/Floral+Shoppe

5. Fishmans 98.12.28 男達の別れ at 赤坂Blitz by Fishmans
   URL: https://www.last.fm/music/Fishmans/Fishmans+98.12.28+%E7%94%B7%E9%81%94%E3%81%AE%E5%88%A5%E3%82%8C+at+%E8%B5%A4%E5%9D%82Blitz

6. Moanin' by Art Blakey & The Jazz Messengers
   URL: https://www.last.fm/music/Art+Blakey+&+The+Jazz+Messengers/Moanin%27

7. Kind of Blue by Miles Davis
   URL: https://www.last.fm/music/Miles+Davis/Kind+of+Blue

8. The Shape of Jazz to Come by Ornette Coleman
   URL: https://www.last.fm/music/Ornette+Coleman/The+Shape+of+Jazz+to+Come

9. Time Out by The Dave Brubeck Quartet
   URL: https://www.last.fm/music/The+Dave+Brubeck+Quartet/Time+Out

10. Undercurrent by Bill Evans & Jim Hall
    URL: https://www.last.fm/music/Bill+Evans+&+Jim+Hall/Undercurrent
```

### tag top-tracks

Get top tracks for a tag.

**Command:**
```bash
lastfm-cli tag top-tracks "electronic" --limit 10
```

**Output:**
```
Top Tracks for tag 'electronic':

1. Feel Good Inc. by Gorillaz
   URL: https://www.last.fm/music/Gorillaz/_/Feel+Good+Inc.

2. Poker Face by Lady Gaga
   URL: https://www.last.fm/music/Lady+Gaga/_/Poker+Face

3. Get Lucky (feat. Pharrell Williams) by Daft Punk
   URL: https://www.last.fm/music/Daft+Punk/_/Get+Lucky+(feat.+Pharrell+Williams)

4. The Less I Know the Better by Tame Impala
   URL: https://www.last.fm/music/Tame+Impala/_/The+Less+I+Know+the+Better

5. Clint Eastwood by Gorillaz
   URL: https://www.last.fm/music/Gorillaz/_/Clint+Eastwood

6. Kids by MGMT
   URL: https://www.last.fm/music/MGMT/_/Kids

7. Midnight City by M83
   URL: https://www.last.fm/music/M83/_/Midnight+City

8. Electric Feel by MGMT
   URL: https://www.last.fm/music/MGMT/_/Electric+Feel

9. One More Time by Daft Punk
   URL: https://www.last.fm/music/Daft+Punk/_/One+More+Time

10. Pumped Up Kicks by Foster the People
    URL: https://www.last.fm/music/Foster+the+People/_/Pumped+Up+Kicks
```

</details>

---

## User Commands

<details>
<summary><strong>User Commands</strong> - Get user info, recent tracks, and top artists</summary>

### user info

Get information about a user.

**Command:**
```bash
lastfm-cli user info "guitaripod"
```

**Output:**
```
User: guitaripod
Real Name: Marcus
Country: None
Age: 0
Playcount: 151060
Registered: 28 April 2010
URL: https://www.last.fm/user/guitaripod
```

### user recent-tracks

Get a user's recent tracks.

**Command:**
```bash
lastfm-cli user recent-tracks "guitaripod" --limit 5
```

**Output:**
```
Recent Tracks for guitaripod:

1. Bad Seed by Metallica
   Album: Reload
   Played: 07/07/2025, 7:14 PM

2. Carpe Diem Baby by Metallica
   Album: Reload
   Played: 07/07/2025, 7:08 PM

3. Slither by Metallica
   Album: Reload
   Played: 07/07/2025, 7:03 PM

4. Better Than You by Metallica
   Album: Reload
   Played: 07/07/2025, 6:58 PM

5. The Unforgiven II by Metallica
   Album: Reload
   Played: 07/07/2025, 6:53 PM
```

### user top-artists

Get a user's top artists.

**Command:**
```bash
lastfm-cli user top-artists "guitaripod" --period 7day --limit 5
```

**Output:**
```
Top Artists for guitaripod (7day):

1. Metallica
   Playcount: 22

2. Drake
   Playcount: 14

3. Final Fantasy Union
   Playcount: 12

4. Pendulum
   Playcount: 12

5. System of a Down
   Playcount: 10
```

</details>

---

## Library Commands

<details>
<summary><strong>Library Commands</strong> - Get a user's library artists</summary>

### library artists

Get all artists in a user's library.

**Command:**
```bash
lastfm-cli library artists "guitaripod"
```

**Output:**
```
Artists in guitaripod's Library:
Total: 8782
Page 1 of 176

- Post Malone
  Playcount: 11937
  URL: https://www.last.fm/music/Post+Malone

- Metallica
  Playcount: 7703
  URL: https://www.last.fm/music/Metallica

- Drake
  Playcount: 7635
  URL: https://www.last.fm/music/Drake

- 植松伸夫
  Playcount: 6273
  URL: https://www.last.fm/music/%E6%A4%8D%E6%9D%BE%E4%BC%B8%E5%A4%AB

- Avenged Sevenfold
  Playcount: 4693
  URL: https://www.last.fm/music/Avenged+Sevenfold

[... and many more artists ...]
```

</details>

---

## My Commands (Authenticated)

<details>
<summary><strong>My Commands</strong> - Commands for the authenticated user</summary>

### my info

Get your own user information (requires authentication).

**Command:**
```bash
lastfm-cli my info
```

**Output:**
```
User: guitaripod
Real Name: Marcus
Country: None
Playcount: 151060
Registered: 1272469115
URL: https://www.last.fm/user/guitaripod
```

### my recent-tracks

Get your recent tracks.

**Command:**
```bash
lastfm-cli my recent-tracks --limit 5
```

**Output:**
```
Your Recent Tracks:
Total Playcount: 151060

1. Bad Seed by Metallica
   Album: Reload
   Played: 07/07/2025, 7:14 PM

2. Carpe Diem Baby by Metallica
   Album: Reload
   Played: 07/07/2025, 7:08 PM

3. Slither by Metallica
   Album: Reload
   Played: 07/07/2025, 7:03 PM

4. Better Than You by Metallica
   Album: Reload
   Played: 07/07/2025, 6:58 PM

5. The Unforgiven II by Metallica
   Album: Reload
   Played: 07/07/2025, 6:53 PM
```

### my top-artists

Get your top artists.

**Command:**
```bash
lastfm-cli my top-artists --period 1month --limit 5
```

**Output:**
```
Your Top Artists (1month):

1. Drake
   Playcount: 136

2. System of a Down
   Playcount: 95

3. Metallica
   Playcount: 74

4. 植松伸夫
   Playcount: 63

5. Avenged Sevenfold
   Playcount: 45
```

### my top-tracks

Get your top tracks.

**Command:**
```bash
lastfm-cli my top-tracks --period 7day --limit 5
```

**Output:**
```
Your Top Tracks (7day):

1. Watercolour by Pendulum
   Playcount: 4

2. Aerials by System of a Down
   Playcount: 4

3. Prison Song by System of a Down
   Playcount: 3

4. Needles by System of a Down
   Playcount: 3

5. Final Fantasy VI - Terra's Theme by Final Fantasy Union
   Playcount: 3
```

### my top-albums

Get your top albums.

**Command:**
```bash
lastfm-cli my top-albums --period overall --limit 5
```

**Output:**
```
Your Top Albums (overall):

1. beerbongs & bentleys by Post Malone
   Playcount: 4775

2. Ride the Lightning by Metallica
   Playcount: 1870

3. Avenged Sevenfold by Avenged Sevenfold
   Playcount: 1696

4. Stoney (Deluxe) by Post Malone
   Playcount: 1612

5. The Marshall Mathers LP2 (Deluxe) by Eminem
   Playcount: 1573
```

</details>

---

## Global Options

All commands support the following global options:

- `--output` or `-o`: Set output format (json, table, pretty, compact)
- `--worker-url`: Override the worker URL from config

Example:
```bash
lastfm-cli --output json artist info "The Beatles"
```

## Configuration

The CLI stores configuration in `~/.config/lastfm-cli/config.json`. This includes:
- Worker URL (default: https://lastfm-proxy-worker.guitaripod.workers.dev)
- Output format preference
- Authentication session (after login)