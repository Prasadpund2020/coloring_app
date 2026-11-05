# Architecture

Phase 1 uses a small Flutter app shell. `main.dart` performs bootstrap and locks
portrait orientation; `app.dart` owns `MaterialApp`; routes are centralized in
`core/routing/app_routes.dart`. Shared design values and widgets live under
`core/`. Feature screens live under their feature folders and currently contain
only navigation placeholders.

The temporary mascot uses Flutter shapes so no network or asset dependency is
needed. Drawing, colouring data, persistence, and parent gating are intentionally
reserved for later phases.
