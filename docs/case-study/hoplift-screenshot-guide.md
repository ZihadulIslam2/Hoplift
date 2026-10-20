# Hoplift — Screenshot Collection Guide

> **Purpose:** Detailed instructions for capturing screenshots to include in the Hoplift business case study.  
> **Target:** The app developer/owner capturing screenshots from a running Hoplift Flutter application.

---

## Pre-Capture Setup

### Demo Data Preparation

Before capturing screenshots, prepare the following demonstration data:

1. **Primary test account:** Create or use an account with:
   - A profile photo uploaded
   - A display name (use your real name or "Alex Thompson" for demo)
   - At least 2-3 completed rides with ratings

2. **Secondary test accounts:** Create 2-3 additional accounts (use different email/social providers) to simulate:
   - A ride with multiple participants
   - An active group chat with messages
   - Ratings between users

3. **Active ride data:** Create at least one ride with:
   - Start and end locations set (use real addresses)
   - Departure time in the near future
   - At least one other participant joined (from secondary account)
   - Some chat messages exchanged

4. **Completed ride data:** Ensure at least one ride has status "completed" with ratings submitted.

> **Privacy note:** Do not use real user data from production. Use test accounts with fictional names or blur any personal information before publishing.

### Device Setup

- Use a **physical device** or **emulator** with a clean, high-resolution display
- Set the device to **English** locale for primary screenshots (capture one in another language for localization evidence)
- Ensure the status bar shows a clean state (full battery, no debug banners)
- Remove the Flutter debug banner (`debugShowCheckedModeBanner: false` is already set in `main.dart`)

---

## Screenshot Plan

### HOP-01 — Onboarding / Welcome Screen

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-01 |
| **Title** | First Impressions — Onboarding Experience |
| **Priority** | Essential |
| **Exact Screen** | `onboarding1.dart` → `OnboardingScreen` |
| **Navigation** | Fresh install → App opens → First onboarding screen appears |
| **Required State** | First-time app launch (clear app data/cache if needed, or delete Hive `isFirstTimeLogin` key) |
| **Capture Instructions** | Capture the first onboarding screen. If there are multiple pages (onboarding1, onboarding2, onboarding3), capture the most visually appealing one. |
| **Business Story** | Shows the user's first impression of the product — professional onboarding communicates product quality |
| **Technical Evidence** | Multi-screen onboarding flow, Hive-based first-launch detection |
| **Suggested Caption** | "Hoplift welcomes new users with a guided onboarding experience before sign-up." |
| **Placement** | Section 1 (Cover) or Section 3 (Solution Overview) |

---

### HOP-02 — Login Screen with Social Options

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-02 |
| **Title** | Multi-Provider Authentication |
| **Priority** | Essential |
| **Exact Screen** | `signin_screen.dart` → `LoginScreen` |
| **Navigation** | Onboarding → Complete or skip → Login screen |
| **Required State** | Unauthenticated state, email and password fields empty |
| **Capture Instructions** | Show the full login form with email field, password field, and all social login buttons (Google, Facebook, Apple). Ensure the "Sign Up" link is visible. |
| **Business Story** | Demonstrates four authentication methods — reducing sign-up friction for different user preferences |
| **Technical Evidence** | `auth.service.js` — Google OAuth, Facebook Graph API, Apple JWKS verification |
| **Suggested Caption** | "Four authentication methods — email with OTP verification, Google, Facebook, and Apple Sign-In — reduce registration friction while maintaining security." |
| **Placement** | Section 5 (Core Features — Authentication) |

---

### HOP-03 — Home Screen / Ride Search

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-03 |
| **Title** | Ride Discovery — Search Interface |
| **Priority** | Essential |
| **Exact Screen** | `search_ride_view.dart` → `SearchScreenView` (Tab 0 of bottom nav) |
| **Navigation** | Login → Home (Search tab is default) |
| **Required State** | Authenticated user. Show the search form with location inputs, date/time picker, and passenger count selector. The greeting widget should show the user's name. |
| **Capture Instructions** | Fill in a "From" location and "To" location with real addresses. Set a date and time. Show the passenger count at 1. Keep the "Search" button visible at the bottom. |
| **Business Story** | The primary user interaction — searching for available rides by origin, destination, time, and passenger count |
| **Technical Evidence** | `SearchRideController`, geospatial `filterRidesService`, `LocationInput` widget with autocomplete |
| **Suggested Caption** | "Users search for rides by entering origin, destination, departure time, and passenger count. The system matches rides using geospatial proximity and direction awareness." |
| **Placement** | Section 3 (The Solution) — Hero screenshot |

---

### HOP-04 — Search Results with Ride Cards

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-04 |
| **Title** | Matched Rides — Search Results |
| **Priority** | Essential |
| **Exact Screen** | `search_result_view.dart` → `SearchResultView` |
| **Navigation** | Home → Fill search form → Tap "Search" |
| **Required State** | At least 2-3 active rides exist that match the search criteria. Rides should show participant avatars, departure time, available seats, and creator information. |
| **Capture Instructions** | Show at least 2 ride cards in the results list. Each card should display: route (from → to), departure time, available seats, creator name/photo, and participant count. If average ratings appear on cards, ensure at least one has a rating. |
| **Business Story** | Demonstrates the result of geospatial + direction-aware matching — only relevant rides shown |
| **Technical Evidence** | `filterRidesService` with `$geoNear`, Haversine distance, bearing calculation |
| **Suggested Caption** | "Search results show rides matched by proximity, direction, and departure time — with participant details, available seats, and average ratings." |
| **Placement** | Section 4 (Core Features — Geospatial Matching) |

---

### HOP-05 — Create Ride Form

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-05 |
| **Title** | Ride Creation — Offer Your Seats |
| **Priority** | Essential |
| **Exact Screen** | `create_ride_view.dart` → `CreateRideView` |
| **Navigation** | Home → Tap "Create a Ride" / "Offer Ride" button |
| **Required State** | Authenticated user, creation form visible |
| **Capture Instructions** | Fill in origin and destination locations, select a departure date/time, set available seats (e.g., 3), and select a baggage type. Show all form fields populated before tapping "Create". |
| **Business Story** | Shows how any user can offer their empty seats — the supply side of the marketplace |
| **Technical Evidence** | `CreateNewRideController`, `createRideService` — creates ride + chatroom + creator bookings atomically |
| **Suggested Caption** | "Any user can create a ride by setting their route, departure time, available seats, and baggage preference. A group chat room is automatically created for coordination." |
| **Placement** | Section 3 (The Solution) or Section 4 (Core Features) |

---

### HOP-06 — Join Ride Bottom Sheet

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-06 |
| **Title** | Joining a Ride — Seat Selection |
| **Priority** | Recommended |
| **Exact Screen** | `join_ride_bottomsheet.dart` → Join ride bottom sheet |
| **Navigation** | Search Results → Tap a ride card → Join bottom sheet appears |
| **Required State** | Viewing a ride with available seats (not your own ride). The bottom sheet should show seat count selector and baggage type options. |
| **Capture Instructions** | Show the join dialog/bottom sheet with seat selection, baggage type dropdown, and the "Join" button. |
| **Business Story** | The moment a passenger commits to a ride — selecting seats and baggage |
| **Technical Evidence** | `joinRideService` — validates seats, creates bookings, adds to chat room, unlocks chat |
| **Suggested Caption** | "Passengers select their seat count and baggage type before joining. The system validates availability in real-time to prevent overbooking." |
| **Placement** | Section 4 (Core Features — Seat Management) |

---

### HOP-07 — Inbox / Chat Room List

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-07 |
| **Title** | Inbox — Active Ride Conversations |
| **Priority** | Essential |
| **Exact Screen** | `inbox_screen.dart` → `InboxScreen` (Tab 1 of bottom nav) |
| **Navigation** | Bottom nav → "Inbox" tab |
| **Required State** | At least 1-2 active chat rooms (user has joined rides). Each room should show the ride destination as the room name, last message preview, and participant avatars. |
| **Capture Instructions** | Show the inbox list with at least one chat room. The chat room card should display: room name (ride destination), last message text, sender name, and timestamp. If participant avatars are shown, include them. |
| **Business Story** | In-context communication — each ride gets its own chat room, no need to exchange personal contact info |
| **Technical Evidence** | `getUserChatRoomsService` with MongoDB aggregation pipeline, Socket.IO `newMessage` events |
| **Suggested Caption** | "Each ride automatically gets a group chat room. The inbox shows active ride conversations with message previews and participant information." |
| **Placement** | Section 4 (Core Features — Chat) |

---

### HOP-08 — Active Chat / Messaging Screen

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-08 |
| **Title** | Real-Time Group Chat |
| **Priority** | Essential |
| **Exact Screen** | `messaging_screen.dart` → Chat/Messaging screen |
| **Navigation** | Inbox → Tap a chat room |
| **Required State** | An active ride with at least 2 participants. Show: user messages, system messages (e.g., "X joined the ride"), message timestamps, and participant info panel if visible. |
| **Capture Instructions** | Exchange a few messages between two test accounts. Ensure at least one system message is visible (e.g., "User joined the ride"). Show the message input area at the bottom. If participant list or ride info is visible in the header, include it. |
| **Business Story** | Real-time coordination — participants discuss pickup details, share updates, and coordinate within the ride context |
| **Technical Evidence** | Socket.IO `newMessage` events, `sendMessageService`, read receipts, system messages |
| **Suggested Caption** | "Real-time group chat with system notifications for ride events. Messages are delivered instantly via WebSocket and include read receipts." |
| **Placement** | Section 4 (Core Features — Chat) or Section 6 (Engineering Challenges) |

---

### HOP-09 — My Bookings (Active Tab)

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-09 |
| **Title** | Booking Management — Active Rides |
| **Priority** | Essential |
| **Exact Screen** | `booking_view.dart` → `BookingScreen` (Tab 2 of bottom nav, "Active" tab) |
| **Navigation** | Bottom nav → "Booking" tab → "Active" tab is default |
| **Required State** | At least 1-2 active bookings. Each booking card should show: ride route, departure time, seat count, status, and available actions (leave/finish). |
| **Capture Instructions** | Show the active bookings list. If cards have action buttons (Leave Ride, Finish Ride), ensure at least one is visible. Show the tab bar with "Active" and "Completed" tabs. |
| **Business Story** | Users manage their rides in one place — see what's upcoming, take action on active rides |
| **Technical Evidence** | `getMyBookingsService` with enriched participant data and ratings aggregation |
| **Suggested Caption** | "The bookings tab gives users a clear view of their active and completed rides with one-tap actions for leaving or completing a ride." |
| **Placement** | Section 4 (Core Features) |

---

### HOP-10 — Post-Ride Rating Screen

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-10 |
| **Title** | Post-Ride Rating — Building Trust |
| **Priority** | Recommended |
| **Exact Screen** | `share_experience_screen.dart` → Rating/experience screen |
| **Navigation** | Active booking → Tap "Finish Ride" → Rating screen appears, OR Completed booking → Rate companions |
| **Required State** | A completed ride with at least 1 other participant to rate. The rating screen should show participant names/photos and star rating widgets. |
| **Capture Instructions** | Show the rating interface with at least one participant's name, photo, and a star rating bar. Set different ratings for different participants if multiple are shown. |
| **Business Story** | Mutual ratings build accountability and help riders make informed decisions about future ride companions |
| **Technical Evidence** | `rateRideParticipantsService` with MongoDB transactions, unique compound index, self-rating prevention |
| **Suggested Caption** | "After completing a ride, participants rate each other on a 1-5 star scale. Ratings are stored per ride and aggregated to build a trust reputation." |
| **Placement** | Section 4 (Core Features — Ratings) |

---

### HOP-11 — Profile Screen

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-11 |
| **Title** | User Profile & Settings |
| **Priority** | Recommended |
| **Exact Screen** | `profile_screen.dart` → `ProfileScreen` (Tab 3 of bottom nav) |
| **Navigation** | Bottom nav → "My Profile" tab |
| **Required State** | Authenticated user with a profile photo, name, and average rating displayed. Settings options should be visible (Edit Profile, Change Password, Language, Help, etc.). |
| **Capture Instructions** | Show the full profile screen with: profile photo, user name, average rating (if displayed), and the list of settings/menu options. |
| **Business Story** | Complete user profile management with identity and reputation information |
| **Technical Evidence** | `ProfileDataController`, Cloudinary avatar upload, `getUserById` service |
| **Suggested Caption** | "Users manage their profile, upload photos to Cloudinary, change language (25 supported), and access help resources." |
| **Placement** | Section 4 (Core Features) |

---

### HOP-12 — Language Selection Screen

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-12 |
| **Title** | Global Localization — 25 Languages |
| **Priority** | Optional |
| **Exact Screen** | `language_screen.dart` → Language selection screen |
| **Navigation** | Profile → Language option |
| **Required State** | Show the language list with current selection highlighted |
| **Capture Instructions** | Capture the language list showing as many languages as possible in a single screenshot. Highlight the current selection. |
| **Business Story** | Demonstrates readiness for global markets — 25 languages from Arabic to Zulu |
| **Technical Evidence** | `easy_localization` with `assets/lang/` directory, `main.dart` locale configuration |
| **Suggested Caption** | "Hoplift supports 25 languages, enabling global market reach from day one." |
| **Placement** | Section 4 (Core Features) or Section 10 (Conclusion) |

---

### HOP-13 — App in Non-English Language

| Field | Details |
|---|---|
| **Screenshot ID** | HOP-13 |
| **Title** | Localization in Action |
| **Priority** | Optional |
| **Exact Screen** | Any main screen (Search, Inbox, or Booking) in a non-English language |
| **Navigation** | Profile → Language → Select Arabic/Spanish/French/etc → Return to Search |
| **Required State** | App language changed to a non-English locale |
| **Capture Instructions** | Capture the Search screen (or another feature-rich screen) with all UI text in the selected language. Arabic (RTL) would be especially impressive for demonstrating RTL support. |
| **Business Story** | Proves localization is functional, not just configured |
| **Technical Evidence** | `easy_localization` runtime locale switching, `.tr()` extension usage throughout UI |
| **Suggested Caption** | "Full UI localization with runtime language switching — shown here in [Language Name]." |
| **Placement** | Section 4 (Core Features — Localization) |

---

## Non-UI Evidence (Code/Architecture)

These features cannot be demonstrated through screenshots alone. Include these as code snippets or diagrams in the case study:

| Evidence | Type | Source |
|---|---|---|
| Geospatial matching algorithm | Code snippet | `ride.service.js` lines 170-404 |
| Vote-kick weighted voting logic | Code snippet + documentation | `ride.service.js` lines 785-1073 |
| Booking overbooking prevention hook | Code snippet | `booking.model.js` lines 56-88 |
| Cron job auto-completion | Code snippet | `finishJob.js` lines 10-112 |
| Socket.IO event architecture | Mermaid diagram | `hoplift-architecture.mmd` |
| MongoDB 2dsphere indexes | Code snippet | `ride.model.js` lines 152-154 |

---

## Screenshot Checklist

Use this checklist to track your progress:

- [ ] **HOP-01** — Onboarding screen (Essential)
- [ ] **HOP-02** — Login screen with social buttons (Essential)
- [ ] **HOP-03** — Home / Search ride form (Essential) ← **Capture first**
- [ ] **HOP-04** — Search results with ride cards (Essential)
- [ ] **HOP-05** — Create ride form (Essential)
- [ ] **HOP-06** — Join ride bottom sheet (Recommended)
- [ ] **HOP-07** — Inbox / chat room list (Essential)
- [ ] **HOP-08** — Active chat / messaging screen (Essential)
- [ ] **HOP-09** — My Bookings / Active tab (Essential)
- [ ] **HOP-10** — Post-ride rating screen (Recommended)
- [ ] **HOP-11** — Profile screen (Recommended)
- [ ] **HOP-12** — Language selection screen (Optional)
- [ ] **HOP-13** — App in non-English language (Optional)

### Capture Order (Recommended)

1. First, set up test data (accounts, rides, bookings, chats, ratings)
2. **HOP-01** — Clear app data, launch for onboarding
3. **HOP-02** — Proceed to login screen
4. **HOP-03** — Log in, capture home/search
5. **HOP-05** — Create a ride
6. **HOP-04** — Search for rides (from secondary account or with matching criteria)
7. **HOP-06** — Join a ride (from secondary account)
8. **HOP-07** — Check inbox (chat room should appear)
9. **HOP-08** — Open chat, exchange messages
10. **HOP-09** — View bookings
11. **HOP-10** — Finish ride, capture rating screen
12. **HOP-11** — View profile
13. **HOP-12, HOP-13** — Language screenshots (optional)

---

*All screenshot IDs reference actual screens discovered in the Flutter codebase. No screenshots reference non-existent screens.*
