# random_user

App Flutter qui affiche des contacts depuis l'API [randomuser.me](https://randomuser.me/).


## Stack

- **Flutter/Dart**
- **Dio** — HTTP
- **Provider** + **ChangeNotifier** — state
- **GoRouter** — routing
- **get_it** + **injectable** — DI générée par `build_runner`
- **shared_preferences** — cache
- **cached_network_image** + **skeletonizer** — images

## Architecture

Clean architecture en 4 couches :

```
lib/
├── core/                 # transversal : network, theme, storage, DI, routing
├── domain/               # entités + repository abstract + use cases (pur Dart)
├── infrastructure/       # models (JSON ↔ entity), data sources, repository impl
├── application/          # controllers (ChangeNotifier)
└── presentation/         # pages, widgets
```

Flux : `presentation` → `application` (controller) → `domain` (use case + repository abstract) ← implémenté par `infrastructure`. Le domain ne dépend que de `core/`.

## Structure détaillée

```
lib/
├── core/
│   ├── di/                # modules @Injectable (un fichier par couche) + injector
│   ├── network/           # HttpClient (Dio wrappé) + exceptions typées
│   ├── routing/           # Routes + GoRouter
│   ├── storage/           # AppPreferencesStorage + CacheKeys
│   ├── task/              # TaskResult<T> + AsyncValue<T> + TaskErr
│   ├── theme/             # AppTheme + AppColors + Spacing + Sizes
│   └── utils/             # dynParser, gap
├── domain/
│   ├── entities/          # User, Name, Location, Picture, PageInfo, UsersResponse
│   ├── repositories/      # UserRepository (abstract)
│   └── usecases/          # GetUsersUseCase, GetUserByIdUseCase
├── infrastructure/
│   ├── models/            # *Model (with fromJson, fromDyn, toJson, toEntity)
│   ├── datasources/       # local/ (SharedPreferences) + remote/ (Dio)
│   ├── errors/            # mapNetworkException
│   └── repositories/      # UserRepositoryImpl
├── application/
│   └── users/             # UsersListController, UserDetailsController
└── presentation/
    ├── common/
    │   ├── theme/         # (vide — design tokens sont dans core/theme)
    │   └── widgets/       # AppCachedImageNetwork, CustomPaginationList
    └── users/             # pages + widgets
```

## Démarrage

```bash
flutter pub get
dart run build_runner build       # génère injector.config.dart
flutter run
```

## Génération de code

Le DI est généré par `injectable` à partir des annotations `@module` dans `lib/core/di/`. Pour regénérer après un changement de module :

```bash
dart run build_runner build
# ou en watch :
dart run build_runner watch --delete-conflicting-outputs
```

## Tests

```bash
flutter test
```

Un smoke test est fourni (`test/widget_test.dart`). Les tests métier (controllers, repository, parser) ne sont pas inclus dans ce livrable.

## API

- Base : `https://randomuser.me`
- Endpoint : `/api/?page={page}&results={results}`
- Stratégie : `page=1, results=50` au premier fetch, puis `page=N+1, results=20` à chaque scroll en bas de liste.

## Conventions

- `AsyncValue<T>` (de `core/task/`) pour l'état UI (initial/loading/success/error)
- `TaskResult<T>` pour les retours use case (ok / err typé via `TaskErr`)
- `NetworkException` hiérarchie scellée (`Transport`, `Unauthorized`, `NotFound`, `Validation`, `Server`, `Unknown`) — mappée en `TaskErr` au niveau du repository
- `dynParser<T>` pour le parsing JSON défensif (renvoie des valeurs par défaut au lieu de lancer)
- `Routes` exposé en objets `Route(name, path)` — utiliser `Routes.usersList.name` et `Routes.usersList.path`
- Design tokens : `Spacing.*` pour paddings, `Sizes.*` pour dimensions
