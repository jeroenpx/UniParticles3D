# UniParticles3D

A simple yet powerful 3D Particle System for Godot 4.3+. UniParticles3D provides an intuitive, modular approach to creating particle effects with a familiar interface inspired by Unity's particle system.

<video src="https://github.com/user-attachments/assets/b901ea3f-beb7-4ea0-9268-0acef65a6628"></video>

## Overview

UniParticles3D uses Godot's RenderingServer multimesh system for efficient rendering while keeping particle logic on the CPU. While not as performant as Godot's GPU-based particle system, it offers:

- Easier and quicker setup
- More intuitive controls
- Visual gizmos for shape editing
- Familiar workflow for Unity developers
- Greater control over individual particles

Perfect for when you just want some simple effects with a quick setup.

## Features

### Core Particle System
- **Emission Control**: Configure[UniParticles3Dmov.webm](https://github.com/user-attachments/assets/5a809f82-5be4-4baa-9247-ed84b21e4d27)
 burst, distance-based and continuous emission with customizable rates and intervals
- **Shape-based Emission**: Multiple emission shapes with detailed controls
  - Cone (with base/volume emission)
  - Sphere
  - Hemisphere
  - Box
  - Circle
  - Edge

### Modular System
The particle system is built with a modular approach, allowing you to enable/disable different features:

#### Main Settings and Play Behaviour
- Control the main settings, duration, starting lifetime, speed, size, gravity and rotation.
- Different options allow for setting a custom number, random between two constants or use a curve for finer control.
- Choose whether to use world space or local space for the simulation.

<img src="https://github.com/user-attachments/assets/2ce24098-8680-4141-93bf-401e0c7e6687" width="50%"/>

#### Emission Module
- Control the maximum amount of particles allowed at any one time
- Emit continuously over time and or over distance
- Configure bursts of particles for fine-tuned control.

<img src="https://github.com/user-attachments/assets/db6c3f67-6d40-4122-b88f-fe7c5074012f" width="50%"/>

#### Shape Module
- Configurable emission shapes with visual gizmos
- Shape-specific properties (radius, angle, length)
- Arc control for circular shapes
- Thickness control for hollow shapes

<img src="https://github.com/user-attachments/assets/7dca55a3-1681-4893-95b1-b0bbfd4ef14a" width="50%"/>

#### Size Module
- Control particle size over lifetime
- Separate width and height controls
- Curve-based animation

<img src="https://github.com/user-attachments/assets/78edd8c7-bbbf-4679-95f8-6fbaa2b176f9" width="50%"/>

#### Velocity Module
- Initial velocity controls
- Velocity over lifetime
- World/local space velocity
- Position and rotation offset controls

<img src="https://github.com/user-attachments/assets/620130da-7980-427b-b33f-fd8a7a87ea71" width="50%"/>

#### Rotation Module
- Rotation over lifetime (Angle of the Texture)
- Orbit controls (Orbit around the node's center)

<img src="https://github.com/user-attachments/assets/41ecb0c6-3298-47ed-93b2-5d2d28fbc4a0" width="50%"/>

#### Color Module
- Color over lifetime using gradient
- Hue variation
- Alpha control

<img src="https://github.com/user-attachments/assets/aed1eed2-602b-4042-89ff-82203c04e299" width="50%"/>

#### Texture Sheet Animation
- Sprite sheet support
- Multiple animation modes
- Frame control over lifetime
- Random starting frame option

<img src="https://github.com/user-attachments/assets/22171c5d-42c0-41dc-890f-e9693b575d75" width="50%"/>

#### Rendering
- Billboard modes
- Velocity-based stretching
- Custom mesh support
- Multiple blend modes
- Material override options

<img src="https://github.com/user-attachments/assets/323b1eaf-3acc-4c9c-821d-dc0ebdd6fd64" width="50%"/>

### Visual Editor
- **Interactive Inspector**: Organized, collapsible sections for each module
- **Live Preview**: Real-time preview of particle effects
- **Visual Gizmos**: Shape visualization in the editor
- **Playback Controls**: Play, pause, restart controls in editor

![image](https://github.com/user-attachments/assets/2aca241f-bc50-42d8-bd48-241525518b29)

## Technical Details

### Rendering System
- Uses RenderingServer's multimesh system for efficient rendering
- CPU-based particle logic for greater control and flexibility
- Custom shader support for various blend modes
- Editor gizmos for visual shape editing

### Performance Considerations
- Best suited for effects with moderate particle counts
- CPU-based updates mean performance scales with particle count
- More memory-efficient than storing individual nodes
- Trade-off between ease of use and maximum performance

## Installation

1. Download or clone this repository (Or download it directly from the Asset Library once its there)
2. Copy the `addons/UniParticles3D` folder into your Godot project's `addons` folder
3. Enable the plugin in Project Settings -> Plugins
4. Add a UniParticles3D node to your scene

## Usage

### Basic Setup

1. Add a UniParticles3D node to your scene
2. Configure the basic emission settings:
   - Emission rate
   - Particle lifetime
   - Initial speed
3. Choose an emission shape and configure its properties
4. Enable desired modules (size, color, rotation, etc.)
5. Configure module-specific properties

### Advanced Features

#### Burst System
Create complex emission patterns using bursts:
- Multiple burst points
- Cycle control
- Probability settings
- Random count ranges

#### Shape Controls
Fine-tune emission shapes with:
- Arc control for circular shapes
- Radius thickness for hollow shapes
- Direction controls
- Position/rotation offset

#### Animation Control
Multiple ways to animate particles:
- Curve-based animation for size, velocity, and rotation
- Color gradients
- Texture sheet animation
- Orbital movement

## Requirements

- Godot 4.3 or higher

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
