# Hoplift — Technical Analysis Report

> **Classification:** Internal Technical Reference  
> **Scope:** Full-stack codebase investigation of Hoplift (backend + Flutter mobile app)  
> **Date:** October 2026

---

## 1. Project Identity

| Field | Value |
|---|---|
| **Project Name** | Hoplift |
| **Repository** | [github.com/ZihadulIslam2/Hoplift](https://github.com/ZihadulIslam2/Hoplift) |
| **Product Type** | Ride-sharing / Carpooling Mobile Application |
| **Description** (from `pubspec.yaml`) | "A ride sharing app" |
| **App Title** (from `main.dart`) | Hoplift |
| **Production API** | `https://api.hopliftapp.com/api/v1` |
| **Version** | 1.0.12+16 (Flutter), 1.0.0 (Backend) |

---

## 2. Technology Stack — Verified Inventory

### 2.1 Backend

| Technology | Version | Responsibility | Engineering Benefit |
|---|---|---|---|
| **Node.js + Express** | Express 4.18 | HTTP server, REST API framework | Lightweight, non-blocking I/O, fast API development |
| **MongoDB + Mongoose** | Mongoose 7.0 | Document database, ODM layer | Flexible schemas for ride/booking data, geospatial indexing |
| **Socket.IO** | 4.8.1 | Real-time WebSocket communication | Instant chat, live ride updates, notifications |
| **JWT (jsonwebtoken)** | 9.0.2 | Access/refresh token authentication | Stateless auth, dual-token rotation |
| **bcrypt** | 5.1.1 | Password hashing | Industry-standard one-way hashing |
| **Helmet** | 6.0 | HTTP security headers | Mitigates common web vulnerabilities |
| **express-rate-limit** | 6.7 | Request throttling | Prevents brute-force / DDoS |
| **xss-clean** | 0.1.1 | XSS input sanitization | Strips malicious scripts from input |
| **express-mongo-sanitize** | 2.2 | NoSQL injection prevention | Strips `$` and `.` operators from user input |
| **Cloudinary** | 2.6 | Cloud image storage and CDN | Scalable media hosting, automatic transformations |
| **Nodemailer** | 6.10 | Transactional email delivery | OTP emails, password reset flows |
| **node-cron** | 4.2.1 | Scheduled background jobs | Auto-complete rides, clean expired chat rooms |
| **Winston** | 3.8.2 | Structured logging | Production-grade log management |
| **Morgan** | 1.10 | HTTP request logging | Request/response audit trail |
| **Multer** | 1.4.5 | Multipart file uploads | Profile image, PDF uploads |
| **google-auth-library** | 10.4 | Google OAuth ID token verification | Social login (Google) |
| **jwks-rsa** | 3.2 | Apple Sign-In JWT verification | Social login (Apple) |
| **Axios** | 1.12 | HTTP client (Facebook Graph API calls) | Social login (Facebook) |
| **Joi** | 17.9 | Input validation schemas | Listed in dependencies; usage not widespread in current codebase |
| **cookie-parser** | 1.4.7 | Cookie handling | Refresh token management |

### 2.2 Flutter Mobile App

| Technology | Version | Responsibility | Engineering Benefit |
|---|---|---|---|
| **Flutter** | SDK ^3.8.1 | Cross-platform mobile UI framework | Single codebase for iOS + Android |
| **GetX** | 4.7.2 | State management, routing, DI controller | Lightweight reactive state, minimal boilerplate |
| **get_it** | 8.0.3 | Service locator / dependency injection | Clean separation of interface vs implementation |
| **Dio** | 5.9 | HTTP client | Interceptors, automatic serialization |
| **socket_io_client** | 3.1.2 | WebSocket client for real-time events | Chat, notifications, ride updates |
| **flutter_secure_storage** | 9.2.4 | Encrypted credential storage | Secure token persistence on device |
| **Hive CE** | 2.15.1 | Lightweight local NoSQL database | Fast key-value cache, onboarding state |
| **easy_localization** | 3.0.3 | Multi-language support | 25 supported locales |
| **dartz** | 0.10.1 | Functional programming (Either type) | Type-safe error handling |
| **flutter_appauth** | 10.0 | OAuth/OIDC native authentication flows | Social login integration |
| **flutter_facebook_auth** | 7.1.2 | Facebook native login SDK | Social login (Facebook) |
| **image_picker** | 1.1 | Camera/gallery image selection | Profile photo upload |
| **flutter_rating_bar** | 4.0.1 | Star rating widget | Post-ride participant ratings |
| **pin_code_fields** | 8.0.1 | OTP input widget | Email verification PIN entry |
| **shimmer** | 3.0 | Loading skeleton animations | Loading state UX |
| **flutter_markdown** | 0.7.7 | Markdown rendering | Terms of service, legal docs |
| **url_launcher** | 6.3.2 | External URL/deep link handling | Help center, external links |
| **path_provider** | 2.1.5 | Platform file paths | Hive initialization |

### 2.3 DevOps & Tooling

| Tool | Purpose |
|---|---|
| **PM2** (`ecosystem.config.js`) | Process manager for production deployment |
| **ESLint** | JavaScript code linting |
| **Prettier** | Code formatting |
| **Jest + Supertest** | Backend unit/integration testing (configured, tests not present in repository) |
| **Nodemon** | Development auto-restart |
| **flutter_launcher_icons** | App icon generation (iOS/Android/Web) |

---

## 3. Architecture Analysis

### 3.1 Backend Architecture

**Pattern:** Entity-based modular architecture (Controller → Service → Model)

Each domain entity has its own directory under `src/entities/` with four files:
- `*.model.js` — Mongoose schema + methods
- `*.service.js` — Business logic layer
- `*.controller.js` — HTTP request handlers
- `*.routes.js` — Express route definitions

**Entities:**
1. **Auth** — User registration (OTP-based), login, social login (Google/Facebook/Apple), token refresh, password management
2. **Ride** — Core ride lifecycle: create, search/filter (geospatial), join, leave, finish, vote-kick, rate participants, ownership transfer
3. **Booking** — Seat reservations tied to rides, status management (active/completed/cancelled), multi-seat bookings
4. **Message** — Chat rooms (ride-based group chats), real-time messaging, read receipts, message editing/deletion
5. **Notification** — In-app notifications with TTL auto-expiry (7 days), typed (join/kick/finish/rating/leave/general)
6. **User** — Profile management, avatar uploads (single + multiple), PDF uploads, admin management

**Middleware Stack (in order):**
1. Helmet (security headers)
2. CORS (permissive, credentials allowed)
3. XSS-Clean
4. MongoDB Sanitize
5. Morgan (request logging)
6. Body parser (JSON limit: 10MB)
7. Cookie parser
8. Global rate limiter
9. Static file serving
10. API router → entity routes
11. 404 handler
12. Error handler

**API Versioning:** All routes under `/api/v1/`

**Real-time Communication:** Socket.IO server with:
- Room-based chat (`room-{chatRoomId}`)
- User-specific notification channels (`user-{userId}`)
- Ride-specific events (`ride-{rideId}`)
- Global event broadcasting for ride status changes

**Background Jobs (node-cron):**
1. **Auto-complete rides** — Every 10 minutes: marks rides as completed if departure was >2 hours ago
2. **Auto-delete expired chat rooms** — Every 2 minutes: removes chat rooms for rides departed >2 hours ago

### 3.2 Flutter App Architecture

**Pattern:** Feature-module architecture with GetX state management + get_it for DI

```
lib/
├── app/                     # App scaffold
│   ├── app_manager.dart     # Global auth state, route decisions
│   ├── init_dependency.dart # Service locator registration
│   ├── routing/             # Route definitions
│   ├── view/                # Bottom nav bar (main shell)
│   └── widget/              # Global widgets (background, logo)
├── core/                    # Shared infrastructure
│   ├── base/                # Base classes
│   ├── common/              # Shared widgets, components
│   ├── component/           # UI components
│   ├── constants/           # API endpoints, cache keys
│   ├── notifiers/           # Snackbar, button status
│   ├── services/            # AppPigeon (HTTP), OAuth, Cache, Debug
│   ├── theme/               # Colors, text styles, gaps
│   └── utils/               # Helpers, extensions
└── modules/                 # Feature modules
    ├── auth/                # Login, register, OTP verify, password reset
    ├── location/            # Location search (autocomplete)
    ├── message/             # Inbox, messaging, chat
    ├── notification/        # Notification list, bell widget
    ├── onboarding/          # Splash, onboarding screens
    ├── profile/             # Profile view/edit, settings, docs
    └── ride&booking/        # Search, create, join, leave, finish, rate, kick
```

**Main Navigation:** 4-tab bottom navigation bar
1. **Search** — Home screen with ride search
2. **Inbox** — Chat rooms for active rides
3. **Booking** — Active + Completed bookings
4. **My Profile** — Profile, settings, language, help

**Localization:** 25 languages supported via `easy_localization`:
Arabic, Bengali, Bosnian, German, Greek, English, Spanish, French, Hindi, Hungarian, Indonesian, Italian, Japanese, Korean, Dutch, Polish, Portuguese, Romanian, Russian, Albanian, Swahili, Thai, Chinese, Zulu

**Auth Flow:**
1. Splash screen (2s delay) → Check cached auth
2. First-time users → Onboarding screens
3. Returning unauthenticated → Login screen
4. Authenticated → Main app (bottom nav)
5. AppPigeon handles automatic token refresh via `RefreshTokenManager`

**Service Layer Pattern:**
Each module follows: `Interface (abstract) → Implementation (concrete) → Controller (GetX)`
- Interfaces registered via `get_it` service locator
- Controllers use `handleFold` with `dartz.Either` for type-safe error handling

---

## 4. Database Schema Analysis

### 4.1 Collections and Relationships

```
User (auth.model.js)
├── _id: ObjectId
├── name, email, phoneNumber, password
├── provider: ['google', 'facebook', 'apple', 'email']
├── providerId, providers[]
├── role: ['USER', 'ADMIN']
├── profileImage, multiProfileImage[], pdfFile
├── address: { country, cityState, roadArea, postalCode, taxId }
├── otp, otpExpires, isVerified, emailVerified
├── refreshToken, lastLogin
├── hasActiveSubscription, subscriptionExpireDate
├── blockedUsers: [ref: User]
├── language, bio
└── timestamps

Ride (ride.model.js)
├── _id: ObjectId
├── creator: ref → User
├── startLocation: { address, lat, lng, location: GeoJSON Point, radius }
├── endLocation: { address, lat, lng, location: GeoJSON Point, radius }
├── departureTime: Date
├── seatCount (default: 4), bookedSeats
├── filters: { departureFlexMinutes, arrivalFlexKm, departureFlexKm }
├── baggageType: ['Large', 'Small', 'None']
├── status: ['active', 'completed', 'cancelled']
├── chatRoom: ref → ChatRoom
├── chatLocked: Boolean (locked until 2nd user joins)
├── kickedVotes: [{ targetUser: ref → User, votedBy: [ref → User] }]
├── ratings: [ref → Rating]
├── price, bearing, deletedByCreator, newCreator
└── timestamps
    INDEXES: departureTime, startLocation.location (2dsphere), endLocation.location (2dsphere)

Booking (booking.model.js)
├── ride: ref → Ride
├── user: ref → User
├── seatBooked (default: 1, min: 1)
├── baggageType: ['Large', 'Small', 'None']
├── status: ['active', 'cancelled', 'completed']
├── joinedAt, leftAt
├── kicked: Boolean
├── cancelReason, cancelledBy: ref → User
└── timestamps
    PRE-SAVE HOOK: validates seat availability via aggregation
    POST-SAVE HOOK: recalculates ride.bookedSeats on cancellation

ChatRoom (chatRoom.model.js)
├── ride: ref → Ride
├── name, isGroup, description, avatar
├── participants: [ref → User]
├── messages: [ref → Message]
└── timestamps

Message (message.model.js)
├── chatRoom: ref → ChatRoom
├── sender: ref → User (optional for 'system' type)
├── message: String
├── type: ['text', 'system', 'notification']
├── attachments: [String]
├── replyTo: ref → Message
├── readBy: [ref → User]
└── timestamps
    INDEX: { chatRoom: 1, createdAt: -1 }

Notification (notification.model.js)
├── user: ref → User
├── type: ['join', 'kick', 'finish', 'rating', 'message', 'general', 'leave']
├── ride: ref → Ride
├── message: String
├── isRead: Boolean
├── expiresAt: Date (default: 7 days)
└── timestamps
    INDEXES: { user: 1 }, { expiresAt: 1, expireAfterSeconds: 0 } (TTL)

Rating (rating.model.js)
├── ride: ref → Ride
├── rater: ref → User
├── ratedUser: ref → User
├── rating: Number (1-5)
├── dismissed: Boolean
└── timestamps
    PRE-SAVE: rater ≠ ratedUser validation
    UNIQUE INDEX: { ride, rater, ratedUser }
```

### 4.2 Geospatial Indexing

The Ride model uses MongoDB `2dsphere` indexes on both `startLocation.location` and `endLocation.location` for:
- `$geoNear` aggregation pipeline stage for proximity-based ride filtering
- Configurable search radius (`departureFlexKm`, `arrivalFlexKm`)

---

## 5. API Endpoint Inventory

### 5.1 Authentication (`/api/v1/auth`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/register/init` | No | Initiate registration with OTP |
| POST | `/register/verify` | No | Verify registration OTP |
| POST | `/login` | No | Email/password login |
| POST | `/social-login` | No | Google/Facebook/Apple OAuth |
| POST | `/refresh-access-token` | No | Refresh JWT tokens |
| POST | `/forget-password` | No | Send password reset OTP |
| POST | `/verify-code` | No | Verify password reset OTP |
| POST | `/reset-password` | No | Set new password |
| POST | `/change-password` | JWT | Change password (authenticated) |
| POST | `/logout` | JWT + Role | Logout |

### 5.2 Ride (`/api/v1/ride`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/` | JWT | Create a new ride |
| GET | `/` | No | Filter/search rides (geospatial) |
| GET | `/:rideId` | No | Get ride details with participants |
| PATCH | `/:rideId` | JWT | Update ride (creator only) |
| DELETE | `/:rideId` | JWT | Soft-delete ride (creator only) |
| POST | `/:rideId/join` | JWT | Join a ride |
| POST | `/:rideId/leave` | JWT | Leave a ride |
| POST | `/:rideId/finish` | JWT | Mark ride as completed |
| PATCH | `/:rideId/transfer` | JWT | Transfer ride ownership |
| POST | `/:rideId/kick` | JWT | Vote to kick a participant |
| GET | `/:rideId/kick-status/:userId` | JWT | Get kick vote status |
| GET | `/:rideId/participants` | JWT | List ride participants |
| PATCH | `/:rideId/meet-point` | JWT | Set meeting point (creator) |
| POST | `/:rideId/rate` | JWT | Rate ride participants |

### 5.3 Booking (`/api/v1/booking`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/my` | JWT | Get user's bookings |
| GET | `/ride/:rideId` | JWT | Get bookings for a ride |
| GET | `/:bookingId` | JWT | Get specific booking |
| PATCH | `/:bookingId` | JWT | Update booking status/baggage |

### 5.4 Message (`/api/v1/message`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/rooms` | JWT | Get user's chat rooms |
| POST | `/rooms` | JWT | Create chat room |
| PATCH | `/rooms/:roomId` | JWT | Update chat room |
| GET | `/ride/:rideId` | JWT | Get ride chat room |
| POST | `/rooms/:roomId/kick/:userId` | JWT | Kick user from chat |
| POST | `/rooms/:roomId/leave` | JWT | Leave chat room |
| GET | `/:roomId` | JWT | Get messages (paginated) |
| POST | `/:roomId` | JWT | Send message |
| PUT | `/read/:roomId` | JWT | Mark messages as read |
| PUT | `/:messageId` | JWT | Edit message |
| DELETE | `/:messageId` | JWT | Delete message |

### 5.5 Notification (`/api/v1/notification`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/user` | JWT | Get user's notifications |
| POST | `/read-all` | JWT | Mark all as read |
| PATCH | `/:notificationId/read` | JWT | Mark single as read |

### 5.6 User (`/api/v1/user`)

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/all-users` | JWT + Admin | List all users |
| GET | `/all-admins` | JWT + Admin | List all admins |
| GET | `/:id` | JWT | Get user by ID |
| PUT | `/:id` | JWT | Update user profile |
| DELETE | `/:id` | JWT + Admin | Delete user |
| POST | `/upload-avatar/:id` | JWT | Upload profile image |
| PUT | `/upload-avatar/:id` | JWT | Update profile image |
| DELETE | `/upload-avatar/:id` | JWT | Delete profile image |
| POST | `/upload-multiple-avatar/:id` | JWT | Upload multiple images |
| POST | `/upload-file/:id` | JWT | Upload PDF file |

---

## 6. Socket.IO Event Inventory

### 6.1 Client → Server Events

| Event | Data | Purpose |
|---|---|---|
| `joinRoom` | `roomId` | Join chat room |
| `leaveRoom` | `roomId` | Leave chat room |
| `registerUser` | `userId` | Register for user-specific notifications |
| `joinRideChat` | `rideId` | Join ride-specific channel |
| `leaveRideChat` | `rideId` | Leave ride-specific channel |

### 6.2 Server → Client Events

| Event | Emitted By | Purpose |
|---|---|---|
| `notification` | Ride Service | General notifications |
| `ride_created` | Ride Service | Broadcast new ride availability |
| `ride_joined` | Ride Service | Broadcast someone joined a ride |
| `ride_left` | Ride Service | Broadcast someone left |
| `ride_deleted` | Ride Service | Ride removed |
| `user_kicked` | Ride Service | Participant removed by vote |
| `kick_vote_update` | Ride Service | Vote progress update |
| `chat_unlocked` | Ride Service | Chat enabled (2nd user joined) |
| `newMessage` | Message Service | New chat message |
| `userJoined` | Ride Service | New participant in chat |
| `userLeft` | Ride/Message Service | Participant left chat |
| `userKicked` | Ride/Message Service | Participant kicked from chat |
| `messagesRead` | Message Service | Read receipt update |
| `editMessage` | Message Service | Message edited |
| `messageDeleted` | Message Service | Message removed |
| `chatRoomDeleted` | Ride/Message/Cron | Chat room removed |
| `roomCreated` | Message Service | New chat room |
| `roomUpdated` | Message Service | Chat room modified |
| `userFinishedRide` | Ride Service | Participant completed ride |
| `got_rated` | Ride Service | Rating received |

---

## 7. Security Implementation Assessment

### 7.1 Implemented Safeguards

| Category | Implementation | Status |
|---|---|---|
| **Password Hashing** | bcrypt with salt rounds 10 | ✅ Implemented |
| **JWT Authentication** | Dual-token (access 7d + refresh 10d) | ✅ Implemented |
| **Token Verification** | `verifyToken` middleware on protected routes | ✅ Implemented |
| **Role-Based Access** | USER, ADMIN roles with middleware guards | ✅ Implemented |
| **HTTP Security Headers** | Helmet middleware | ✅ Implemented |
| **XSS Prevention** | xss-clean middleware | ✅ Implemented |
| **NoSQL Injection Prevention** | express-mongo-sanitize | ✅ Implemented |
| **Rate Limiting** | express-rate-limit (configurable window) | ✅ Implemented |
| **CORS** | Configured (currently permissive `origin: true`) | ⚠️ Functional but broad |
| **Input Validation** | Joi listed but validation mainly in service layer | ⚠️ Partial |
| **File Upload Validation** | Multer with field-level config | ✅ Implemented |
| **Password Change** | Requires old password verification | ✅ Implemented |
| **OTP Expiry** | 10-minute OTP window | ✅ Implemented |
| **Notification TTL** | 7-day auto-expiry via MongoDB TTL index | ✅ Implemented |
| **Token Storage (Mobile)** | flutter_secure_storage (encrypted) | ✅ Implemented |

### 7.2 Identified Gaps (Recommendations)

| Gap | Risk Level | Recommendation |
|---|---|---|
| `.env` file committed to repository | **High** | Add `.env` to `.gitignore`, rotate all exposed credentials |
| CORS `origin: true` allows all origins | Medium | Restrict to known app domains/deep links |
| No request body validation middleware (Joi schemas not used) | Medium | Add validation middleware to route handlers |
| Self-vote prevention on kick is service-level only | Low | Already handled correctly in service |
| No automated test files present | Medium | Add integration tests for critical flows |

---

## 8. Feature Implementation Status

| Feature | Backend | Flutter | Status |
|---|---|---|---|
| Email registration with OTP | ✅ | ✅ | **Fully Implemented** |
| Email/password login | ✅ | ✅ | **Fully Implemented** |
| Google OAuth login | ✅ | ✅ | **Fully Implemented** |
| Facebook login | ✅ | ✅ | **Fully Implemented** |
| Apple Sign-In | ✅ | ✅ | **Fully Implemented** |
| Password reset (OTP-based) | ✅ | ✅ | **Fully Implemented** |
| Password change | ✅ | ✅ | **Fully Implemented** |
| Profile management | ✅ | ✅ | **Fully Implemented** |
| Avatar upload (Cloudinary) | ✅ | ✅ | **Fully Implemented** |
| Create ride (geospatial) | ✅ | ✅ | **Fully Implemented** |
| Search/filter rides (geo + time + seats) | ✅ | ✅ | **Fully Implemented** |
| Direction-aware ride matching | ✅ | — | **Backend Implemented** |
| Join ride (with seat selection) | ✅ | ✅ | **Fully Implemented** |
| Leave ride | ✅ | ✅ | **Fully Implemented** |
| Finish ride | ✅ | ✅ | **Fully Implemented** |
| Democratic vote-kick | ✅ | ✅ | **Fully Implemented** |
| Post-ride participant ratings | ✅ | ✅ | **Fully Implemented** |
| Real-time group chat (per ride) | ✅ | ✅ | **Fully Implemented** |
| Chat lock/unlock mechanism | ✅ | ✅ | **Fully Implemented** |
| Message editing & deletion | ✅ | ✅ | **Fully Implemented** |
| Read receipts | ✅ | ✅ | **Fully Implemented** |
| In-app notifications | ✅ | ✅ | **Fully Implemented** |
| Ride auto-completion (cron) | ✅ | — | **Backend Only** |
| Chat auto-cleanup (cron) | ✅ | — | **Backend Only** |
| Ownership transfer on creator leave | ✅ | — | **Backend Implemented** |
| Baggage type selection | ✅ | ✅ | **Fully Implemented** |
| Multi-language support (25 locales) | — | ✅ | **Frontend Only** |
| Onboarding flow | — | ✅ | **Frontend Only** |
| Admin user management | ✅ | — | **Backend Only** |
| User blocking | ✅ (model) | — | **Schema Only** |
| Subscription management | ✅ (model fields) | — | **Schema Only** |
| Stripe integration | ✅ (model field) | — | **Schema Only** |

---

## 9. Key Source File References

### Backend

| File | Purpose | Lines |
|---|---|---|
| `backend/index.js` | Entry point, MongoDB connection | 19 |
| `backend/src/app.js` | Express app, Socket.IO setup, middleware | 136 |
| `backend/src/core/app/appRouter.js` | Central route registration | 19 |
| `backend/src/core/config/config.js` | Environment variable exports | 30 |
| `backend/src/core/middlewares/authMiddleware.js` | JWT verification, role guards | 80 |
| `backend/src/entities/auth/auth.model.js` | User schema (130 lines, comprehensive) | 130 |
| `backend/src/entities/auth/auth.service.js` | Auth logic: register, login, social, tokens | 505 |
| `backend/src/entities/ride/ride.model.js` | Ride schema with GeoJSON, votes, virtuals | 159 |
| `backend/src/entities/ride/ride.service.js` | **Core business logic** — 1287 lines | 1287 |
| `backend/src/entities/booking/booking.model.js` | Booking schema with seat validation hooks | 112 |
| `backend/src/entities/booking/booking.service.js` | Booking management with participant enrichment | 210 |
| `backend/src/entities/message/message.service.js` | Chat rooms, messaging, aggregation pipelines | 607 |
| `backend/src/entities/notification/notification.model.js` | Notification with TTL auto-expiry | 49 |
| `backend/src/lib/finishJob.js` | Cron: auto-complete expired rides | 113 |
| `backend/src/lib/autoDeleteExpiredChatRooms.js` | Cron: clean up expired chat rooms | 57 |
| `backend/src/lib/cloudinaryUpload.js` | Cloudinary integration | ~22KB |

### Flutter App

| File | Purpose |
|---|---|
| `flutter-app/lib/main.dart` | App entry, localization, routing |
| `flutter-app/lib/app/app_manager.dart` | Global auth state, controller initialization |
| `flutter-app/lib/app/init_dependency.dart` | GetIt service registration |
| `flutter-app/lib/app/view/bottom_nab_bar_page.dart` | 4-tab navigation shell |
| `flutter-app/lib/core/constants/api_endpoints.dart` | Complete API endpoint mapping |
| `flutter-app/lib/modules/auth/screen/signin_screen.dart` | Login UI |
| `flutter-app/lib/modules/ride&booking/ui/view/search_ride_view.dart` | Home/search screen |
| `flutter-app/lib/modules/ride&booking/ui/view/create_ride_view.dart` | Ride creation form |
| `flutter-app/lib/modules/ride&booking/ui/view/booking_view.dart` | Active + Completed tabs |
| `flutter-app/lib/modules/message/ui/view/inbox_screen.dart` | Chat room list |
| `flutter-app/lib/modules/profile/ui/screen/profile_screen.dart` | Profile & settings |
| `flutter-app/lib/modules/ride&booking/controller/kickout_rider_controller.dart` | Vote-kick UI controller |
| `flutter-app/lib/modules/ride&booking/controller/rate_ride_controller.dart` | Post-ride rating controller |

---

## 10. Limitations and Risks

### 10.1 Security

1. **Exposed credentials:** The `.env` file is committed to the repository with real MongoDB URI, Cloudinary keys, Google OAuth client ID, email credentials, and JWT secrets. This is a critical security risk.
2. **Obfuscated code in `ecosystem.config.js`:** The PM2 configuration file contains heavily obfuscated JavaScript appended to the config. This code uses `eval`-style patterns and should be investigated for potential security implications.

### 10.2 Technical

1. **No automated tests:** Jest and Supertest are configured but no test files exist in the repository.
2. **Commented-out code:** Significant commented-out code in `auth.service.js` (lines 380-504) suggests ongoing refactoring.
3. **Duplicate field definitions:** The User model defines `provider` and `providerId` twice (lines 38-46 and 51-58).
4. **Package name mismatch:** Flutter package is named `ttrueno_fo827e642a0c4`, suggesting it was scaffolded from a template; the app title is correctly "Hoplift".
5. **No input validation middleware:** Joi is installed but not used as route-level validation.

### 10.3 Scalability

1. **In-memory Socket.IO:** No Redis adapter configured; limits horizontal scaling.
2. **Cron jobs run in-process:** Auto-completion and chat cleanup jobs run in the same Node.js process; may need separation for multi-instance deployments.
3. **Aggregation pipeline complexity:** The `filterRidesService` and `getRideChatRoomService` use complex multi-stage aggregation pipelines that could benefit from caching at scale.

---

## 11. Assumptions Requiring Confirmation

1. **Your role:** The analysis does not establish whether you developed both backend and frontend, or contributed to specific parts. Clarification needed for the case study.
2. **Team size:** It's unclear if this was built solo or with a team. The `.env` email references (`sauravsarkar.developer@gmail.com`, `bdcallingjahidul@gmail.com`) suggest multiple contributors.
3. **Production status:** The API at `api.hopliftapp.com` suggests production deployment, but current usage metrics are unknown.
4. **App Store presence:** Whether the Flutter app is published on App Store / Play Store is not verified.
5. **The obfuscated code block** in `ecosystem.config.js` — its purpose and origin should be investigated.

---

*End of Technical Analysis*
