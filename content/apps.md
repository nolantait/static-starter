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
[systems](<%= link "_posts/bevy/systems.md" %>) can update our
[world](<%= link "_posts/bevy/worlds.md" %>).

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
[bevy_rapier](<%= link "_posts/bevy/physics/rapier.md" %>) you do so a plugin
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

### Plugin configuration

Keeping your plugin boundaries clean means you should be able to add or remove
plugins and features should be enabled or disabled without breaking the rest of
your game.

We can configure our plugins by providing options on the struct that implements
`Plugin`:

<!-- examples/apps.rs -->
```rust
pub struct CameraPlugin {
    debug: bool
}

impl Plugin for CameraPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, initialize_camera);

        if self.debug {
            app.add_plugins(DebugCameraPlugin);
        }
    }
}
```

There are also `PluginGroup` types which allow us to group related plugins
together and then configure them later, which can be great for writing a plugin
that others can add to their game:

<!-- examples/apps.rs -->
```rust
mod game {
    use bevy::prelude::*;
    use bevy::app::PluginGroupBuilder;
    use super::logic::LogicPlugin;
    use super::camera::CameraPlugin;
    use super::physics::PhysicsPlugin;

    pub struct GamePlugins;

    impl PluginGroup for GamePlugins {
        fn build(self) -> PluginGroupBuilder {
            PluginGroupBuilder::start::<Self>()
                .add(CameraPlugin::default())
                .add(PhysicsPlugin::default())
                .add(LogicPlugin)
        }
    }
}
```

This will let us (or anyone consuming your plugins) configure exactly how the
set of plugins runs in the context of our app:

<!-- examples/apps.rs -->
```rust
fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugins(
            game::GamePlugins
                .build()
                .disable::<physics::PhysicsPlugin>()
        )
        .run();
}
```

## Running apps

When we run an `App` we are calling its app runner function.

Depending on the type of runner function, the call usually never returns,
running our game in an infinite loop.

We can customize the default runner function by configuring it when we build our
`App`:

<!-- examples/apps.rs -->
```rust
// This app wil run once
fn main() {
    App::new()
        .add_plugins(
            DefaultPlugins.set(
                ScheduleRunnerPlugin::run_once()
            )
        )
        .add_plugins(game::GamePlugins.build())
        .run();
}
```

<!-- examples/apps.rs -->
```rust
// This app wil run 60 times per second
fn main() {
    App::new()
        .add_plugins(
            DefaultPlugins.set(
                ScheduleRunnerPlugin::run_loop(
                    Duration::from_secs_f64(
                        1.0 / 60.0
                    )
                )
            )
        )
        .add_plugins(game::GamePlugins.build())
        .run();
}
```

We can even provide our own custom runner function if the default doesn't suit
our game loop:

<!-- examples/custom_runner.rs -->
```rust
#[derive(Resource)]
struct Input(String);

fn my_runner(mut app: App) {
    println!("Type stuff into the console");
    for line in std::io::stdin().lines() {
        {
            let mut input = app.world.resource_mut::<Input>();
            input.0 = line.unwrap();
        }
        app.update();
    }
}

fn main() {
    App::new()
        .set_runner(my_runner)
        .run();
}
```

This will run our game loop once every time we type something into the console
while the game is running.

## Schedules

Your app has a "main schedule" which contains app logic that is evaluate each 
game tick (`App::update()`). This is the schedule you are adding to when you
call `add_systems` on your `App`.

Schedules are stored separately from the `App` and are called by a particular 
`ScheduleLabel` which acts a handle.

There are the following `ScheduleLabel` for your main schedule:

1. `PreStartup`
2. `Startup`
3. `PostStartup`
4. `First`
5. `PreUpdate`
6. `StateTransition`
7. `RunFixedUpdateLoop` which runs `FixedUpdate` conditionally
8. `Update`
9. `PostUpdate`
10. `Last`

On your first run your startup schedules will fire:

```
`PreStartup` -> `Startup` -> `PostStartup`
```

Then your normal game loop begins:

```
`First` -> `PreUpdate` -> `StateTransition` -> `RunFixedUpdateLoop` -> `Update` -> `PostUpdate` -> `Last`
```

Interestingly the way that `RunFixedUpdateLoop` is implemented is that it will 
run the schedule `FixedUpdate` only when a certain amount of time has passed.

Here is a sketch of what this looks like internally in Bevy:

<!-- examples/exclusive_system.rs -->
```rust
#[derive(Resource)]
struct FixedTimestepState {
    accumulator: f64,
    step: f64,
}

// An exclusive system that runs our FixedUpdate schedule manually
fn fixed_timestep_system(world: &mut World) {
    world.resource_scope(|world, mut state: Mut<FixedTimestepState>| {
        let time = world.resource::<Time>();
        state.accumulator += time.delta_seconds_f64();

        while state.accumulator >= state.step {
            world.run_schedule(FixedUpdate);
            state.accumulator -= state.step;
        }
    });
}

fn main() {
    App::new()
        .add_systems(Update, fixed_timestep_system)
        .run();
}
```

This means that if we are running game tests the behaviour for your systems
added to the schedule `FixedUpdate` won't run until the correct amount of time
has passed.

<!-- examples/exclusive_system.rs -->
```rust
#[cfg(test)]
mod tests {
    fn hello_world() {
        println!("Hello World!");
    }

    fn test_fixed_game_loop() {
        let app = App::new();
        app.add_systems(FixedUpdate, hello_world);

        app.update();  // This won't actually run the system
    }
}
```

There are no easy solutions here so I've been changing my fixed system unit
tests to add to the `Update` schedule instead to be more controllable.

## App states

Your `App` has a particular state it is in at any given time which determines
which `Schedule` your app runs.

Your `App` acts like a finite state machine and your logic triggers moving
from one state to another. A finite state machine (FSM) is a model of
computation be in exactly one of a finite number of states at any given time.


### Creating our states

States in Bevy are any enum or struct that implements the `States` trait.

<!-- examples/app_state.rs:6 -->
```rust
#[derive(Debug, Clone, Eq, PartialEq, Hash, Default, States)]
enum AppState {
    #[default]
    MainMenu,
    InGame,
    Paused,
}

fn spawn_menu() {
    // Spawn a menu
}

fn play_game() {
    // Play the game
}

fn main() {
    App::new()
        // Add our state to our app definition
        .init_state::<AppState>()
        // We can add systems to trigger during transitions
        .add_systems(OnEnter(AppState::MainMenu), spawn_menu)
        // Or we can use run conditions
        .add_systems(Update, play_game.run_if(in_state(AppState::InGame)))
        .run();
}
```

When you call `App::init_state<S>` Bevy will add a resource for both `State<S>`
and `NextState<S>` to your app. It will also add systems for handling
transitioning between states.

Your `NextState<S>` resource is holding an `Option<S>` which starts with `None`.
So a transition is triggered if this `NextState<S>` is given a
`Some(YourState)`.

The system `apply_state_transition<S>` added by `App::init_state<S>` will then
run in the `PreUpdate` stage of your app to trigger the `OnExit(PreviousState)`
and `OnEnter(YourState)` schedules once before finally transitioning to the next
state you defined.

We cannot transition back to the same state we are on. So if you accidentally
set the `NextState` to the current state nothing will happen.

If we wanted to create explicit transitions we could implement the logic on our
state:

<!-- examples/app_state.rs:14 -->
```rust
impl AppState {
    fn next(&self) -> Self {
        match *self {
            AppState::MainMenu => AppState::InGame,
            AppState::InGame => AppState::Paused,
            AppState::Paused => AppState::InGame
        }
    }
}
```

### Changing states

Changing the state of your app will change the `Schedule` that runs each tick.

When you transition to a new app state `OnExit(State)` and `OnEnter(State)`
schedules are run before transitioning to the states `Schedule`.

We can trigger these changes by using the `NextState` resource from within our
systems:


<!-- examples/app_state.rs:32 -->
```rust
fn pause_game(
    mut next_state: ResMut<NextState<AppState>>,
    current_state: Res<State<AppState>>,
    input: Res<ButtonInput<KeyCode>>
) {
    if input.just_pressed(KeyCode::Escape) {
        next_state.set(AppState::MainMenu);
    }
}
```


## Sub-apps

Apps can also hold sub apps which are of a different `SubApp` type. Each
`SubApp` contains its own `Schedule` and `World` which are separate from your
main `App`.

The main reason for having the distinction between apps and their sub apps is
to enable pipelined rendering. Here is an example from `bevy::camera`:

```rust
//  https://github.com/bevyengine/bevy/blob/60773e6787d177e97458f9fcf118985906762b2a/crates/bevy_render/src/camera/mod.rs#L38
impl Plugin for CameraPlugin {
    fn build(&self, app: &mut App) {
        // ...
        if let Ok(render_app) = app.get_sub_app_mut(RenderApp) {
            render_app
                .init_resource::<SortedCameras>()
                .add_systems(ExtractSchedule, extract_cameras)
                .add_systems(Render, sort_cameras.in_set(RenderSet::ManageViews));
            let camera_driver_node = CameraDriverNode::new(&mut render_app.world);
            let mut render_graph = render_app.world.resource_mut::<RenderGraph>();
            render_graph.add_node(crate::main_graph::node::CAMERA_DRIVER, camera_driver_node);
        }
        // ...
    }
}
```

But they can also be used to separate the logic of your game into isolated
units.

Lets say we were making a game where we had separate chunks of our game we
wanted to process completely separately and then sync with the main game world:

<!-- examples/chunks -->
```rust
use bevy::app::{App, AppLabel, Plugin, SubApp};
use bevy::prelude::*;
use std::collections::HashMap;

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq, AppLabel)]
pub struct ChunkApp;

#[derive(Default, Clone, Debug)]
enum ChunkState {
    Red,
    Green,
    #[default]
    Blue,
}

#[derive(Resource, Default, Clone)]
struct Chunk {
    id: u32,
    state: ChunkState,
}

#[derive(Resource)]
struct Chunks(HashMap<u32, Chunk>);

struct ChunksPlugin;

impl Plugin for ChunksPlugin {
    fn build(&self, app: &mut App) {
        let mut sub_app = App::new();

        sub_app
            .insert_resource(Chunk::default())
            .add_systems(Update, |mut chunk: ResMut<Chunk>| match chunk.state {
                ChunkState::Red => chunk.state = ChunkState::Green,
                ChunkState::Green => chunk.state = ChunkState::Blue,
                ChunkState::Blue => chunk.state = ChunkState::Red,
            });

        app.insert_sub_app(ChunkApp, SubApp::new(sub_app, sync_chunks));
    }
}

fn sync_chunks(app_world: &mut World, sub_app: &mut App) {
    let mut chunks = app_world.resource_mut::<Chunks>();
    let chunk = sub_app.world.resource::<Chunk>();

    chunks.0.insert(chunk.id, chunk.clone());
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugins(ChunksPlugin)
        .insert_resource(Chunks(HashMap::new()))
        .add_systems(Update, read_chunks)
        .run();
}

fn read_chunks(chunks: ResMut<Chunks>) {
    for chunk in chunks.0.values() {
        println!("{:?}", chunk.state);
    }
}
```

Here we've added our `ChunkApp` into our main app. We use the `sync_chunks`
function as the callback for our sub app which syncs the data through the
resources in each app.

Running the app will print "Blue" then "Red" then "Green" over and over as the
chunks sync from the sub apps to the main app.

For a more complete example with more performance concerns you can check out
`pipelined_rendering.rs` in `bevy/crates/bevy_render` which uses async.

## Multithreading

Apps by default will run on multiple threads. The `Scheduler` is working hard to
try and run your systems in parallel when they have disjoint sets of queries.

We can configure this behaviour by changing the `ThreadPoolOptions` of the
`TaskPoolPlugin`:

<!-- examples/multithreading.rs -->
```rust
fn main() {
    App::new()
        .add_plugins(DefaultPlugins.set(TaskPoolPlugin {
            task_pool_options: TaskPoolOptions::with_num_threads(4),
        }))
        .run();
}
```

## Running headless apps

If you want to run your app without spawning a window or using any rendering
systems, and with the minimum amount of resources, we can use `MinimalPlugins` 
instead of the `DefaultPlugins` we normally add.

```rust
    App::new()
        .add_plugins(MinimalPlugins)
        .add_systems(Update, hello_world_system)
        .run();
```

This can be useful for writing and running tests that include various plugins
from your game but don't need to be displayed on the screen.

If instead you wanted most other systems to run like Bevy's assets, scenes, etc
but not render to your screen you could configure the `DefaultPlugins` to do so:

<!-- examples/headless.rs:0 -->
```rust
use bevy::prelude::*;
use bevy::render::{
    settings::{WgpuSettings,RenderCreation},
    RenderPlugin
};

fn main() {
    App::new()
        .add_plugins(DefaultPlugins.set(RenderPlugin {
            synchronous_pipeline_compilation: true,
            render_creation: RenderCreation::Automatic(WgpuSettings {
                backends: None,
                ..default()
            }),
        }))
        .run();
}
```
