---
layout: post
title: Bevy Apps
date: 2024-03-02
description: >-
    Learn how to control your core game loop and structure the logic of your
    Bevy games using apps. This guide will teach you everything about apps 
    and how to use them to build a game in Bevy.
categories:
    - bevy
tags:
    - featured
sources:
    - https://github.com/bevyengine/bevy/blob/main/crates/bevy_app/src/lib.rs
    - https://github.com/bevyengine/bevy/blob/main/crates/bevy_render/src/pipelined_rendering.rs
    - https://github.com/bevyengine/bevy/tree/main/examples/app
    - https://bevy-cheatbook.github.io/programming/app-builder.html
    - https://bevy-cheatbook.github.io/programming/states.html
    - https://www.youtube.com/watch?v=S__j8qyb_gk
---

Apps are containers for both the logic and data of your game. Our `App` is what
controls the loop of our game so that our
[systems](/bevy/systems) can update our
[world](/bevy/world).

There are two core parts of every `App`:
1. `World` which holds your data (entities, components)
2. `Schedule` which holds your logic (systems)

Your `App` also holds a pointer to a "run function" (which we can override) that
control the actual event loop by advancing the `Schedule` which applies your
logic (systems) to the `World`.

The `App` interface is using a builder pattern which returns the modified `App`
each time we call a method so we can chain them together until we call `run`.

<!-- examples/apps.rs -->
```rust
fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Update, hello_world_system)
        .run();
}

fn hello_world_system() {
    println!("hello world");
}
```
The `DefaultPlugins` adds the core plugins that allow your game to render on a
window provided by your operating system. Unless you are trying to run in a
headless mode, or have a good reason to, we always include this in our `App`
definitions.

## Plugins

Bevy uses an architecture that lets you organize your game by splitting features
into individual plugins and then adding them back to the main app.

This can be useful to ensure a particular resource, event or asset is loaded
first and then our systems run after that.

Its also useful in enabling us to toggle on or off certain features of our game
by simply removing a plugin from our app definition.

When you include or publish a library like
[bevy\_rapier](<%= link "_posts/bevy/physics/rapier.md" %>) you do so a plugin
so we can add them into to our apps.

In general we should aim to keep our plugins encapsulated functionality to a
minimum. Many small plugins should be preferred, with a few larger plugins like
`GamePlugin` assembling from the smaller pieces.

<!-- examples/apps.rs -->
```rust
fn main() {
    App::new()
        .add_plugins(GamePlugin)
        .add_plugins(PhysicsPlugin)
        .add_plugins(CameraPlugin)
        .run()
}
```

We create a plugin by implementing `Plugin` on a struct and defining a
method `build` which should mutate the `App` passed to it by performing the
necessary setup such as adding systems, resources and events to your game:

<!-- examples/apps.rs -->
```rust
pub struct CameraPlugin;

impl Plugin for CameraPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, initialize_camera);
    }
}

fn initialize_camera(mut commands: Commands) {
    commands.spawn(Camera2dBundle::default());
}
```

Usually I find it convenient to keep the `main.rs` file quite clean and move
core logic out to a plugin like `GamePlugin` which can further call other
plugins needed to run core parts of your game.
