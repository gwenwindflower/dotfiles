# D2 Diagram Patterns

Adapt these as structural starting points. Keep only relationships supported by the source material.

## Architecture

Use containers for real boundaries and ELK when nested routing is dense.

```d2
direction: right

users: Users {shape: person}

platform: Analytics platform {
  web: Web app
  api: API
  worker: Query worker

  web -> api: HTTPS
  api -> worker: execute
}

data: Data plane {
  warehouse: Warehouse {shape: cylinder}
  cache: Cache {shape: cylinder}
}

users -> platform.web
platform.worker -> data.warehouse: SQL
platform.api -> data.cache
```

## Sequence diagram

Sequence diagrams use ordinary D2 connections inside `shape: sequence_diagram`. Declaration order controls actor and message order.

```d2
login: Sign-in flow {
  shape: sequence_diagram

  user: User
  app: Web app
  idp: Identity provider

  user -> app: Sign in
  app -> idp: Authorize
  idp -> user: Authenticate
  user -> idp: Credentials
  idp -> app: Authorization code
  app -> user: Session
}
```

Groups inside a sequence diagram organize interactions while actors remain in the shared sequence scope. Use groups only when they clarify phases.

## Entity-relationship diagram

`sql_table` children are columns. ELK routes relationships to exact rows.

```d2
users: Users {
  shape: sql_table
  id: uuid {constraint: primary_key}
  email: text {constraint: unique}
}

orders: Orders {
  shape: sql_table
  id: uuid {constraint: primary_key}
  user_id: uuid {constraint: foreign_key}
  total: decimal
}

orders.user_id -> users.id
```

Represent schema constraints that affect understanding; omit incidental columns when the goal is a conceptual model.

## Decision flow

Use semantic classes and labeled edges. Color can reinforce meaning but must not carry it alone.

```d2
direction: down

classes: {
  decision: {
    shape: diamond
    style.fill: "#fff3bf"
    style.stroke: "#e67700"
  }
  terminal: {
    shape: oval
  }
}

start: Start {class: terminal}
valid: Valid? {class: decision}
publish: Publish
revise: Revise
done: Done {class: terminal}

start -> valid
valid -> publish: yes
valid -> revise: no
revise -> valid: retry
publish -> done
```

## Multi-board composition

Use steps for cumulative state and an animated SVG/GIF or multipage export when the sequence itself matters.

```d2
title: Deployment {shape: text; near: top-center}

steps: {
  1: {
    developer -> repository: push
  }
  2: {
    repository -> ci: trigger
  }
  3: {
    ci -> production: deploy
  }
}
```

Use `layers` for independent drill-down boards and `scenarios` to override a shared base. Read the official [composition overview](https://d2lang.com/tour/composition/) before combining nested boards or connection overrides.
