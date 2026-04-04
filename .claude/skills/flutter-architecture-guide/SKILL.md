---
name: flutter-architecture-guide
description: Explain and apply the Flutter architecture used in this project. Use when analyzing, extending, or creating features that should follow this app's structure, dependency injection, routing, and Cubit-based state management.
---

# Flutter Architecture Guide

## Instructions

### Step 1: Inspect the project structure first
Start by understanding the project's top-level organization before making changes.

This project follows a feature-first structure with shared app-level code in `lib/app`, reusable cross-cutting code in `lib/Core`, and business features in `lib/features`.

Use this mental model:

- `lib/app`
  - App bootstrap and dependency injection
- `lib/Core`
  - Shared constants, design system, widgets, routing, networking, errors, utils, and extensions
- `lib/features/<feature>`
  - Feature-specific clean architecture layers

Typical feature structure:

- `data/`
  - `datasources/`
  - `models/`
  - `repositories/`
- `domain/`
  - `entities/`
  - `repositories/`
  - `usecases/`
- `presentation/`
  - `cubit/` or `controllers/`
  - `screens/`
  - `widgets/`

When reviewing a feature, confirm whether it follows this layering before adding code.

### Step 2: Follow the app's architectural conventions
Use the same conventions found in this codebase:

#### Dependency injection
This project uses `get_it` through the global service locator in `lib/app/dependenc_injections.dart`.

Follow these patterns:
- Register external services first
- Register data sources next
- Register repository implementations against domain repository interfaces
- Register use cases after repositories
- Register Cubits/feature state objects last

Expected flow:

1. External dependency
2. Data source
3. Repository
4. Use case
5. Cubit / presentation state manager

When adding a new feature, update DI in the same order.

#### Routing
This project uses `go_router` with centralized routing in `lib/Core/routing/rout_config.dart`.

Follow these rules:
- Keep route definitions centralized
- Use route constants from `app_routs.dart`
- Keep redirect logic inside router configuration
- If a flow depends on auth or setup state, integrate it into the router redirect lifecycle instead of scattering navigation checks across screens

#### State management
This project uses `flutter_bloc` / Cubit.

Follow these patterns:
- Place Cubits inside `presentation/cubit/`
- Keep UI state in state classes
- Let Cubits call use cases instead of repositories directly when possible
- Avoid placing Firebase, storage, or networking logic in screens
- Keep screens focused on rendering and user interaction

#### Domain contracts
This project uses repository interfaces in the `domain` layer and implementations in the `data` layer.

Follow these rules:
- Define abstract repository contracts in `domain/repositories/`
- Implement them in `data/repositories/`
- Return domain-friendly results
- Keep feature business rules in use cases
- Prefer passing through use cases rather than calling repository implementations from UI code

### Step 3: Respect the shared Core layer
Before creating a new utility or widget, check whether the shared `Core` layer already contains a reusable version.

Common shared areas in this project:
- `Core/design_system/` for theme, tokens, and styling primitives
- `Core/Widgets/` for reusable widgets
- `Core/constants/` for app-wide enums, assets, and constants
- `Core/network/` for network abstractions
- `Core/errors/` for failures and error handling
- `Core/routing/` for app navigation rules
- `Core/extentions/` and `Core/design_system/extensions/` for helpers and theme extensions

Do not duplicate logic already supported by Core.

### Step 4: Mirror the auth feature as the main reference
Use `features/auth` as the primary reference implementation for this codebase's architecture.

When creating or evaluating a new feature, compare it against the auth module for:
- Layer separation
- Repository abstraction
- Use case boundaries
- DI registration style
- Screen + Cubit interaction
- Routing integration

Use this reference mapping:

- Domain contract example:
  - `lib/features/auth/domain/repositories/auth_repo.dart`
- DI example:
  - `lib/app/dependenc_injections.dart`
- Routing example:
  - `lib/Core/routing/rout_config.dart`

If a new feature deviates from these patterns, prefer aligning it unless there is a strong reason not to.

### Step 5: Apply a feature implementation checklist
When adding a new feature, follow this sequence:

1. Create the feature folder under `lib/features/<feature_name>/`
2. Add `domain/entities/` for core business entities if needed
3. Add `domain/repositories/` for abstract contracts
4. Add `domain/usecases/` for each business action
5. Add `data/datasources/` for remote/local integrations
6. Add `data/models/` for serialization and persistence models
7. Add `data/repositories/` for repository implementations
8. Add `presentation/cubit/` or `presentation/controllers/`
9. Add `presentation/screens/` and `presentation/widgets/`
10. Register everything in `lib/app/dependenc_injections.dart`
11. Add routes in `lib/Core/routing/`
12. Reuse `Core` design system, widgets, constants, and helpers instead of recreating them

### Step 6: Keep code quality aligned with this project
While implementing or reviewing code, enforce these project-specific standards:

- Keep feature code inside its own feature folder
- Keep reusable cross-feature code in `Core`
- Prefer small, focused use cases
- Keep repositories abstract in `domain` and concrete in `data`
- Use centralized DI registration
- Use centralized routing
- Keep UI and business logic separate
- Reuse existing design tokens such as spacing and typography
- Avoid introducing a new architectural style inside only one feature

### Step 7: Use this skill as a review guide
When asked to review architecture in this project, evaluate code using these questions:

1. Is the code in the correct layer?
2. Is feature-specific logic kept inside the feature?
3. Is shared logic placed in `Core`?
4. Are repository contracts defined in `domain`?
5. Are repository implementations defined in `data`?
6. Are use cases used as the business boundary?
7. Is state handled through Cubit/state classes instead of screen-only logic?
8. Is DI registered in `lib/app/dependenc_injections.dart`?
9. Is routing integrated centrally in `lib/Core/routing/`?
10. Does the implementation resemble the `auth` feature's structure?

If the answer to several of these is "no", recommend refactoring toward the established project pattern.

## References from this project

### Dependencies and architecture signals
From `pubspec.yaml`, the main architecture-related packages include:
- `flutter_bloc`
- `get_it`
- `go_router`
- `dartz`
- `equatable`
- Firebase packages
- local storage packages such as `shared_preferences`, `flutter_secure_storage`, and `hive`

These indicate:
- Cubit-based state management
- service-locator DI
- centralized routing
- repository/use-case style domain separation
- remote + local data source composition

### Important files to study
- `lib/app/dependenc_injections.dart`
- `lib/Core/routing/rout_config.dart`
- `lib/features/auth/domain/repositories/auth_repo.dart`

## Output expectations
When using this skill, produce guidance or code that:
- matches the current Flutter project structure
- follows the feature-first clean architecture style used here
- integrates with `get_it`, `go_router`, and Cubit
- keeps shared concerns in `Core`
- treats `features/auth` as the canonical example
