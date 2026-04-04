# Auth Integration DI & Routing Review

## Summary (overall health)
- DI and routing are centralized in the expected layers, which matches the project conventions.
- The auth integration is structurally close to the desired architecture, but the current wiring is not reliable enough for a production auth flow.
- Main weaknesses are in app-level auth session ownership, route contracts, startup bootstrap, and mismatches between screen actions and router-driven state transitions.

## Critical Issues

### 1. Router listens to a potentially different `AuthCubit` instance than the UI
- **File:** `lib/app/dependenc_injections.dart`
- `AuthCubit` is registered with `sl.registerFactory(...)`, while `RouterNotifier` is registered as a lazy singleton using `sl<AuthCubit>()`.
- Because factory registration returns a new cubit each time, the router can listen to one auth cubit while screens interact with another.
- This breaks centralized auth-driven navigation and can prevent redirects from reacting to login/logout/setup changes.

### 2. Redirects navigate to `/login`, but `/login` requires `state.extra as UserType`
- **File:** `lib/Core/routing/rout_config.dart`
- The login route builder does `final userType = state.extra as UserType;`.
- Redirect logic returns `AppRoutes.login` without supplying `extra`.
- The same problem exists for `/register`.
- This creates a runtime crash on common redirect/deep-link flows.

### 3. Router redirects fully setup users to a route that is not defined
- **Files:** `lib/Core/routing/rout_config.dart`, `lib/Core/routing/app_routs.dart`
- `AuthStatus.fullySetup` maps to `AppRoutes.home`.
- There is no `GoRoute` for `AppRoutes.home` inside `_routes`.
- The success path after completing auth/setup can therefore land in the error screen instead of the app shell.

### 4. Verify email screen performs the wrong action for progressing auth flow
- **File:** `lib/features/auth/presentation/screens/verify_email.dart`
- The “Checked” button calls `context.read<AuthCubit>().sendEmailVerification()`.
- That resends the email instead of checking whether the email is verified.
- Router logic expects state to move from `emailUnVerified` to `locationNotSelected`, but this screen never triggers `checkEmailVerified()`.
- This blocks the intended auth flow.

### 5. Startup auth resolution is not guaranteed on the same auth source observed by router
- **Files:** `lib/Core/routing/router_notifire.dart`, `lib/features/auth/presentation/cubit/Auth/auth_cubit.dart`, `lib/app/dependenc_injections.dart`
- `RouterNotifier` only subscribes to `_authCubit.stream`.
- `AuthCubit` starts with `AuthStatus.unKnown` and `OnboardingStatus.unKnown`.
- Unless `checkAuthState()` is called on the exact same cubit instance used by `RouterNotifier`, the router may never resolve onboarding/auth state correctly at startup.

## Medium Issues

### 1. `RouterNotifier` leaks its stream subscription
- **File:** `lib/Core/routing/router_notifire.dart`
- `_authCubit.stream.listen((_) => notifyListeners());` is not stored or cancelled in `dispose()`.
- For infrastructure code bridging state to router refresh, lifecycle cleanup should be explicit.

### 2. Onboarding commits business state before the user confirms with “Next”
- **File:** `lib/features/auth/presentation/screens/on_boarding.dart`
- Tapping a user-type card immediately calls `context.read<AuthCubit>().completeOnboarding(userType);`.
- That means onboarding completion and user-type persistence happen before the visible confirmation step.
- This makes the flow harder to reason about and can trigger router state changes earlier than intended.

### 3. Forgot-password action points to the wrong route
- **File:** `lib/features/auth/presentation/screens/login.dart`
- The button navigates to `AppRoutes.completeProfile` instead of `AppRoutes.forgotPassword`.
- This breaks the public auth flow and conflicts with the router’s setup/public segmentation.

### 4. Location picker flow does not align cleanly with router-driven guarded navigation
- **File:** `lib/features/auth/presentation/screens/location_picker.dart`
- On confirmation it calls `context.read<AuthCubit>().locationSelected();` and then `Navigator.of(context).pop();`.
- In a `go_router`-guarded setup flow, imperative `pop()` can conflict with redirect-driven navigation.
- Also, this screen appears to advance auth status through `locationSelected()` without clearly persisting the actual selected address/coordinates through `locationAddress(...)`, which can leave router-visible setup state ahead of actual saved data.

### 5. `AuthState.isLoggedIn` is too broad for route policy
- **File:** `lib/features/auth/presentation/cubit/Auth/auth_state.dart`
- `isLoggedIn` is derived from `user != null && authStatus != AuthStatus.unauthenticated`.
- Router decisions should rely on explicit session/setup states rather than nullable user presence.

### 6. Bootstrap failure handling hides real errors
- **File:** `lib/features/auth/presentation/cubit/Auth/auth_cubit.dart`
- In `checkAuthState()`, failure from `isFirstTimeUseCase()` is folded into `true`.
- This converts local storage/infrastructure failures into first-time onboarding flow, masking the actual problem and potentially misrouting returning users.

## Minor Improvements

### 1. Naming and typo inconsistencies in core integration files reduce clarity
- **Files:** `lib/app/dependenc_injections.dart`, `lib/Core/routing/rout_config.dart`, `lib/Core/routing/router_notifire.dart`, `lib/Core/routing/app_routs.dart`
- Examples include `dependenc_injections`, `rout_config`, `router_notifire`, and `/coplete-profile`.
- These are not immediate blockers, but they increase maintenance cost and misuse risk in core wiring.

### 2. `AuthStatus.authentecated` appears unused
- **File:** `lib/features/auth/presentation/cubit/Auth/auth_state.dart`
- The enum contains `authentecated`, but current routing/cubit logic uses the more specific setup states instead.
- Keeping overlapping unused statuses makes route policy less clear.

### 3. Error page recovery is incomplete
- **File:** `lib/Core/routing/rout_config.dart`
- `_ErrorPage` renders an `AppButton` labeled to go home, but no `onPressed` is provided.
- This weakens recovery from navigation failures.

### 4. Auth state mixes durable route-driving state with transient UI messaging
- **Files:** `lib/features/auth/presentation/cubit/Auth/auth_state.dart`, `lib/features/auth/presentation/cubit/Auth/auth_cubit.dart`
- `errorMessage` and `successMessage` live in the same state object as `authStatus` and `onboardingStatus`.
- This can cause unnecessary router refreshes and rebuilds for transient snackbar concerns.

## Suggested Refactor Plan (step by step)

1. **Make auth session ownership app-scoped**
   - Register the app-level auth session cubit/state source as a singleton or lazy singleton if router and app shell both depend on it.
   - Ensure `RouterNotifier` and the top-level `BlocProvider` resolve the same instance.

2. **Make startup auth bootstrap explicit**
   - Call `checkAuthState()` during app startup on that same shared auth instance.
   - If needed, add a splash/bootstrap route in `Core/routing` and only evaluate route guards after initial auth resolution.

3. **Fix auth route contracts**
   - Remove unsafe `state.extra as UserType` assumptions from login/register routes.
   - Prefer one of:
     - a dedicated user-type selection route before login/register,
     - path/query params with safe parsing,
     - or null-safe fallback handling.
   - Redirect targets must always be buildable without crashing.

4. **Define real post-auth destinations centrally in router**
   - Add a route for `AppRoutes.home`, or map `fullySetup` to role-based destinations like `serviceHome` / `providerHome` using the domain user type.
   - Keep this decision in centralized router policy.

5. **Align screen actions with the auth state machine**
   - `verify_email.dart`: “Checked” should call `checkEmailVerified()`.
   - `login.dart`: forgot-password should go to `AppRoutes.forgotPassword`.
   - `on_boarding.dart`: only persist onboarding/user type on “Next”.
   - `location_picker.dart`: persist both location selection and address/location data consistently, and let router handle the next route instead of manually popping in a guarded flow.

6. **Harden `RouterNotifier`**
   - Store the stream subscription.
   - Cancel it in `dispose()`.

7. **Separate durable auth state from transient UI messages**
   - Keep route-driving session/setup state inside the auth state observed by the router.
   - Move snackbar/toast events to a separate presentation event mechanism or otherwise isolate them from route refresh concerns.

8. **Preserve failure semantics across boundaries**
   - Do not silently convert onboarding/local storage failures into first-time onboarding.
   - Keep domain/infrastructure failures explicit and choose a deliberate safe fallback in bootstrap flow.

## Testing Plan (with examples)

### 1. DI tests
- **Target:** `lib/app/dependenc_injections.dart`
- Verify router and UI use the same auth session instance.
- Verify dependencies required by `AuthCubit` are registered before cubit/router resolution.

### 2. Router redirect matrix tests
- **Target:** `lib/Core/routing/rout_config.dart`
- Example cases:
  - unknown state => no redirect during bootstrap
  - first-time user on `/login` => `/onboarding`
  - unauthenticated user on `/verify-email` => `/login`
  - email-unverified user on `/register` => `/verify-email`
  - fully setup user on `/complete-profile` => actual home route

### 3. Route contract tests
- **Target:** `lib/Core/routing/rout_config.dart`
- Direct navigation to `/login` and `/register` without `extra` should not throw.
- Redirect into auth routes should build safely.

### 4. RouterNotifier tests
- **Target:** `lib/Core/routing/router_notifire.dart`
- Verify listeners are notified when auth state changes.
- After refactor, verify no notifications occur after disposal.

### 5. Auth/router state-transition tests
- **Target:** `lib/features/auth/presentation/cubit/Auth/auth_cubit.dart`
- Example cases:
  - login success with unverified email => `emailUnVerified`
  - `checkEmailVerified()` success => `locationNotSelected`
  - location confirmation => `profileIncomplete`
  - profile completion => `fullySetup`
  - logout => `unauthenticated`

### 6. Widget/integration tests
- **Targets:** auth screens + router
- Example flows:
  - onboarding -> login
  - login success -> verify email
  - verify email checked -> map picker
  - location confirmed -> complete profile
  - complete profile -> home
  - protected route while logged out -> safe redirect to login