---
name: clean-architecture
description: Apply the project's CLEAN architecture rules whenever adding a new feature or updating an existing one. Trigger on requests like "add X feature", "implement X", "wire X to the backend", "update the X feature", or any change that touches lib/domain, lib/data, or lib/presentation. Enforces the three-layer split (domain / data / presentation), repository interfaces, use cases, DTO→entity mappers, and DI conventions for this Flutter app.
---

# CLEAN Architecture

This project follows CLEAN architecture with three layers that must not cross-depend incorrectly. Apply these rules every time you add or modify a feature.

## Layers

### Domain Layer (`lib/domain/`)
- Business logic and domain entities
- Defines repository interfaces
- Defines use cases — access data only through repository interfaces
- Pure Dart — no Flutter, no JSON, no external dependencies

### Data Layer (`lib/data/`)
- Implements repository interfaces from the domain layer
- Uses adapters, data sources, and mappers to wrap external APIs
- Converts API models → domain entities via `toDomain()` mappers

### Presentation Layer (`lib/presentation/`)
- Depends on domain layer only
- BLoCs call use cases from the domain layer
- Screens and widgets live here

**CRITICAL**: Data layer and Presentation layer MUST NOT depend on each other.

## Directory Map

```
lib/
  domain/       # Business logic, entities, repository interfaces, use cases, core logic
  data/         # Repository implementations, API models, mappers, data sources
  presentation/ # Screens, BLoCs, contracts
  res/          # Design tokens, typography
  l10n/         # Localization (ARB files)
  injection/    # Dependency injection setup
```

## Dependency Injection

`main.dart` is the app entry point and DI setup. Use `@injectable` annotations on classes.
Register dependencies with `@singleton`, `@lazySingleton`, or `@injectable`.
Run `dart run build_runner build --delete-conflicting-outputs` after changing annotations.

## How to apply when working on a feature

When the user asks to add or change a feature, walk through the layers in this order:

1. **Domain first.** Identify the entity (in `lib/domain/entities/`), the repository interface it needs (`lib/domain/repositories/`), and the use case the presentation layer will call (`lib/domain/use_cases/`). Keep these files pure Dart — no `package:flutter/*`, no `package:cloud_firestore/*`, no JSON.
2. **Data layer next.** Add a DTO under `lib/data/models/` with a `toDomain()` mapper, a data source under `lib/data/sources/` (this is where Firestore / HTTP / platform code lives), and a `*RepositoryImpl` under `lib/data/repositories/` that implements the domain interface.
3. **Presentation last.** Screens and BLoCs in `lib/presentation/` call use cases — never repositories or data sources directly. Import only from `lib/domain/`. Lay out each feature using the folder structure below.
4. **DI registration.** Wire the new classes into `lib/injection/` using `@injectable` / `@singleton` / `@lazySingleton`, then run `dart run build_runner build --delete-conflicting-outputs`.

## Folder structure

First verify that the folder structure is correct. If not, create the missing folders.
```
presentation/
├── <feature_name>/
│       ├── bloc/
│       │   └── <feature_name>_bloc.dart
│       │   └── <feature_name>_event.dart
│       │   └── <feature_name>_state.dart
│       ├── pages/
│       │   └── <feature_name>_page.dart
│       └── widgets/
```

## Freezed

Domain entities, BLoC events, and BLoC states must use the `freezed` package.

- `lib/domain/entities/*.dart` — every domain entity is a `@freezed` class.
- `lib/presentation/<feature>/bloc/<feature>_event.dart` — events are a single `@freezed` sealed union.
- `lib/presentation/<feature>/bloc/<feature>_state.dart` — state is a `@freezed` class (or sealed union when the screen has distinct modes like initial / loading / loaded / error).

Each freezed file declares its `part '<name>.freezed.dart';` (and `part '<name>.g.dart';` if it needs JSON, though domain entities should not). Run `dart run build_runner build --delete-conflicting-outputs` after adding or changing a freezed class.

DTOs in `lib/data/models/` are not required to be freezed — they exist to mirror the wire format and produce a domain entity via `toDomain()`.

## Common mistakes to avoid

- Importing a Firestore type, JSON map, or `package:flutter/*` from anywhere under `lib/domain/`.
- Calling a repository directly from a BLoC or widget — always go through a use case.
- Importing from `lib/data/` inside `lib/presentation/` (or vice versa).
- Putting the `toDomain()` mapper on the domain entity instead of the DTO — mappers belong in the data layer.
- Adding a new entity without also defining the repository interface and use case for it.
