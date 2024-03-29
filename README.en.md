# Voxelamming - Programming Learning App with AR

Voxelamming is an iOS compatible AR-based programming learning app for programming beginners and generative artists.

Voxelamming Studio is a new version that supports Apple Vision Pro. Operation is almost the same as Voxelamming, but some functions are limited.

<a href="https://apps.apple.com/us/app/voxelamming/id6451427658?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1690502400" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_ladder.png" alt="VoxelLadder" width="100%"/></p>

[//]: # (<p align="center"><video width="1280" height="720" controls>)

[//]: # (    <source src="video/voxelamming_top_video.mp4" type="video/mp4">)

[//]: # (</video></p>)


* Read this in other languages: [English](README.en.md), [日本語](README.md)*

## What is Voxelamming?

Voxelamming = Voxel + Programming

Voxelamming is a programming learning app with AR. It can be used for free on AR-compatible iPhones and iPads (iOS 16 and above). You can have fun placing voxels (the smallest units in 3D space, similar to pixels) in a virtual space that you have programmed on your computer.

## How to Use

### Preparing Your Computer

Both Windows and Mac are supported. If the programming language (Python, Node.js, Ruby, Swift, Scratch3 MOD) is not installed on your computer, please install the language you want to use. Data communication between the computer and the device (iPhone, iPad, Apple Vision Pro) uses an Internet connection (they do not need to be connected to the same network). Once this is done, your computer is ready.

### Placing a Plane Anchor

#### iPhone, iPad

Launch the voxelamming app. The first time you launch the app, it will ask for permission to use the camera, please grant it by selecting "Yes". Once the camera is launched, ARKit will automatically search for a real-world plane. When the plane detection marker (red-green-blue coordinate axes) appears, tap the screen to place a plane anchor. The plane anchor is made up of black and white tiles. With this, you are ready to place voxels.

#### Apple Vision Pro

Launch the voxelamming vision application. Tap the "Set Base Anchor" button to place the base anchor. The base anchor consists of white and black tiles. Now you are ready to place voxels. Note that the base anchor can be moved by dragging.

### Modeling (Programming) Voxels

On your computer (Windows, Mac), program the "voxel data" for modeling the voxels. The voxel data includes information such as "location, color, size, and placement interval". The supported languages are Scratch3 MOD, Python, JavaScript (Node.js), Ruby, and Swift.

Let's create a script. Please refer to the scripts in the sample folder. Don't forget to match the variable room_name (roomName) to the string displayed in the center of the device (iPhone, iPad, Apple Vision Pro) screen in order to connect to the WebSocket server's room.

Then, use the loop and conditional expressions of each language to create voxel data. The position of the voxel is specified by the x, y, and z axis values, with the plane anchor as the reference. The x-axis represents left and right, the y-axis represents up and down, and the z-axis represents depth (the front is positive) (the unit is centimeters). The size of the voxel is specified as a decimal based on 1.0 cm. The color is specified as a decimal from 0 to 1 in RGB values. Then, specify the interval at which voxels are placed in seconds. By specifying the interval at which voxels are placed, the voxels will be placed over time instead of all at once.

### Build AR Voxels

When you run the script, the voxel data is sent to the device (iPhone, iPad, Apple Vision Pro) via WebSocket communication. Once the data is received, AR voxels are placed based on the plane anchor on the device screen.

If the WebSocket server is on break, data transmission may fail. In that case, please wait for a while and try again.

## Explanation of Methods

I will explain the methods to use in the script. The method names for each language are as follows.

* set_box_size(size): Sets the size of the voxel. The unit is centimeters. The default is 1.0.
* set_room_name(room_name): Specifies the room name for communication with the device (iPhone, iPad, Apple Vision Pro). The room name is displayed in the center of the screen when the application is run. By specifying the same room name, communication between the device and the computer can be established.
* set_box_size(size): Sets the size of the voxel. The unit is in centimeters. The default is 1.0.
* set_build_interval(interval): Sets the interval for placing voxels. It can express the animation of placing voxels one by one. The unit is in seconds. The default is 0.01.
* change_shape: Changes the shape of the voxel. You can choose from a cube (box), sphere (square), or plane (plane).
* change_material(is_metallic, roughness): This function changes the material of the voxel. Setting is_metallic to "on" will make it metallic in appearance. roughness represents the roughness and should be specified as a decimal value between 0 and 1.
* create_box(x, y, z, r, g, b, alpha): Places a voxel. Specifies the position on the x-axis, y-axis, z-axis, and color. Colors are specified as RGBA values from 0 to 1 in decimal. Alpha represents transparency, specified as a decimal from 0 to 1.
* create_box(x, y, z, texture)： Place a textured voxel, specifying the x-, y-, and z-axis positions and the texture: choose from grass, stone, dirt, planks, or bricks.
* remove_box(x, y, z): Removes a voxel. Specifies the position on the x-axis, y-axis, z-axis. (If there is no voxel at the specified position, it does nothing)
* write_sentence(sentence, x, y, z, r, g, b, alpha): Writes a sentence in voxels. Specifies the position on the x-axis, y-axis, z-axis, and color in RGBA values.
* set_light(x, y, z, r, g, b, alpha, intensity, interval): Places a light. Specifies the position (x, y, z) and color (r, g, b, alpha) of the light. The default intensity is 1000. To make it blink, specify the interval in seconds (if it is 0, it does not blink).
* set_command(command): Sets a command.The following commands are implemented: "axis" (to display coordinates), "japaneseCastle" (to build a Japanese castle), "float" (to place voxels at the decimal point), and "liteRender" (to simplify drawing and lighten processing).
* draw_line(x1, y1, z1, x2, y2, z2, r, g, b, alpha): Draws a line between two points. x1, y1, z1 are the starting points, x2, y2, z2 are the endpoints. The color is specified as RGBA values from 0 to 1 in decimal.
* send_data(): Sends voxel data to the device (iPhone, iPad, Apple Vision Pro). Execute when placing AR voxels.
* clear_data(): Initializes voxel data. It also initializes the size and interval (execute this when you want to initialize the voxel data after sending).
* translate(x, y, z, pitch, yaw, roll): Specifies the position (x, y, z) and angle (pitch, yaw, roll) of the node that groups voxels.
* animate(x, y, z, pitch, yaw, roll, scale, interval): Node animation. Specifies movement (x, y, z), rotation (pitch, yaw, roll), magnification (scale), and placement interval (interval). (Due to RealityKit limitations, rotational angle must be less than 180 degrees)
* animate_global(x, y, z, pitch, yaw, roll, scale, interval): All voxels animation based on the base anchor. Specifies movement (x, y, z), rotation (pitch, yaw, roll), magnification (scale), and placement interval (interval). (Due to RealityKit limitations, rotational angle must be less than 180 degrees)
* push_matrix(): Saves the current matrix. Stores the current node position and angle on the stack.
* pop_matrix(): Restores the matrix saved by push_matrix(). Restores the position and angle of a node saved in the stack.
* frame_in(): Starts taking frame. Run this before placing voxels. Frames can be played back as an animation.
* frame_out(): Finish shooting the frame. Execute after placing voxels.
* set_frame_fps(fps): sets the frame rate. Default is 2.
* set_frame_repeats(repeats): Sets the number of times a frame is replayed. Default is 10.

Please read snake_case as camelCase. (set_box_size -> setBoxSize)

## Script Examples

You can try examples of scripts in [the sample folder](https://github.com/creativival/voxelamming/tree/main/sample). When you run the following script, a voxel like the image will be placed.

### Scratch3 MOD

Load the voxelamming extension and create a script.

[Play the sample project in Xcratch](https://xcratch.github.io/editor/#https://creativival.github.io/voxelamming-extension/projects/example.sb3)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_scratch3_en.png" alt="voxelamming_scratch3_en" width="100%"/></p>

### Scratch3 MOD (Turtle Programming)

You can use Turtle Programming to set up voxels on Scratch3 MOD. It is recommended for beginners in programming, especially children, as it allows them to intuitively set up voxels.

[Xcratchで、サンプルプロジェクトを再生する](https://xcratch.github.io/editor/#https://creativival.github.io/voxelamming-turtle-extension/projects/example.sb3)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_turtle_scratch3_en.png" alt="voxelamming_turtle_scratch3_en" width="100%"/></p>

### Python (3.6+)

#### Script

```python
# Python
from build_box import BuildBox

room_name = "1000"
build_box = BuildBox(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)
build_box.translate(0, 0, 0, pitch=0, yaw=0, roll=0)
build_box.animate(0, 0, 10, pitch=0, yaw=30, roll=0, scale=2, interval= 10)

for i in range(100):
  build_box.create_box(-1, i, 0, r=0, g=1, b=1)
  build_box.create_box(0, i, 0, r=1, g=0, b=0)
  build_box.create_box(1, i, 0, r=1, g=1, b=0)
  build_box.create_box(2, i, 0, r=0, g=1, b=1)

for i in range(50):
  build_box.remove_box(0, i * 2 + 1, 0)
  build_box.remove_box(1, i * 2, 0)

build_box.send_data()
```

#### Run script

```bash
$ sample/python
$ python main.py

or  

$ python3 main.py
```

### JavaScript (Node.js)

#### Script

```javascript
// JavaScript (Node.js)
import BuildBox from './buildBox.mjs';

const roomName = '1000';
const buildBox = new BuildBox(roomName);

buildBox.setBoxSize(0.5);
buildBox.setBuildInterval(0.01);

for (let i = 0; i < 100; i++) {
  buildBox.createBox(-1, i, 0, 0, 1, 1);
  buildBox.createBox(0, i, 0, 1, 0, 0);
  buildBox.createBox(1, i, 0, 1, 1, 0);
  buildBox.createBox(2, i, 0, 0, 1, 1);
}

for (let i = 0; i < 50; i++) {
  buildBox.removeBox(0, i * 2, 0);
  buildBox.removeBox(1, i * 2 + 1, 0);
}

buildBox.sendData();
```

#### Run script

```bash
$ sample/javascipt
$ node main.mjs
```

### Ruby

#### Script

```ruby
# Ruby
require_relative 'build_box'

room_name = '1000'
build_box = BuildBox.new(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)

for i in 0...100
  build_box.create_box(-1, i, 0, 0, 1, 1)
  build_box.create_box(0, i, 0, 1, 0, 0)
  build_box.create_box(1, i, 0, 1, 1, 0)
  build_box.create_box(2, i, 0, 0, 1, 1)
end

for i in 0...50
  build_box.remove_box(0, i * 2, 0)
  build_box.remove_box(1, i * 2 + 1, 0)
end

build_box.send_data
```

#### Run script

```bash
$ sample/ruby
$ ruby main.rb
```

### Swift

#### Script

```swift
// Swift
import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    let roomName = "1000"
    let buildBox = BuildBox(roomName: roomName)
    buildBox.setBoxSize(0.5)
    buildBox.setBuildInterval(0.01)

    Task {
        do {
            for i in 0..<100 {
                buildBox.createBox(-1, Double(i), 0, r: 0, g: 1, b: 1)
                buildBox.createBox(0, Double(i), 0, r: 1, g: 0, b: 0)
                buildBox.createBox(1, Double(i), 0, r: 1, g: 1, b: 0)
                buildBox.createBox(2, Double(i), 0, r: 0, g: 1, b: 1)
            }

            for i in 0..<50 {
                buildBox.removeBox(0, Double(i * 2), 0)
                buildBox.removeBox(1, Double(i * 2 + 1), 0)
            }

            try await buildBox.sendData()
        } catch {
            print("An error occurred: \(error)")
        }
    }

    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10)) // Or longer depending on your needs
} else {
    fatalError("This script requires iOS 15.0 / macOS 12.0 or later.")
}
```

#### Run script

```bash
$ cd sample/swift/main
$ swift run
```
## Showcase

### Square

<p align="center"><img src="https://creativival.github.io/voxelamming/image/square_sample.png" alt="square_sample" width="50%"/></p>

### Node placement

<p align="center"><img src="https://creativival.github.io/voxelamming/image/move_sample.png" alt="move_sample" width="50%"/></p>

### Node rotation

<p align="center"><img src="https://creativival.github.io/voxelamming/image/rotation_sample.png" alt="rotation_sample" width="50%"/></p>


### Node animation

<p align="center"><img src="https://creativival.github.io/voxelamming/image/animation_sample.png" alt="animation_sample" width="50%"/></p>


### Global animation

<p align="center"><img src="https://creativival.github.io/voxelamming/image/global_animation_sample.png" alt="animation_sample" width="50%"/></p>

### Write sentence

<p align="center"><img src="https://creativival.github.io/voxelamming/image/sentence_sample.png" alt="sentence_sample" width="50%"/></p>

### Map

The liteRender command is used to lighten the drawing.

<p align="center"><img src="https://creativival.github.io/voxelamming/image/japan_map.png" alt="japan_map" width="50%"/></p>

### Model created by MagicaVoxel

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxel_model.png" alt="voxel_model" width="50%"/></p>

### Transparency

<p align="center"><img src="https://creativival.github.io/voxelamming/image/set_alpha_sample.png" alt="set_alpha_sample" width="50%"/></p>

### Draw line

<p align="center"><img src="https://creativival.github.io/voxelamming/image/draw_line.png" alt="draw_line" width="50%"/></p>

### Change shape (box, sphere, plane)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/change_shape.png" alt="change_shape" width="50%"/></p>

### Change material

<p align="center"><img src="https://creativival.github.io/voxelamming/image/change_material.png" alt="change_material" width="50%"/></p>

### Lighting (Only iOS)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/light_sample.png" alt="light_sample" width="50%"/></p>

### Command

<p align="center"><img src="https://creativival.github.io/voxelamming/image/command_sample.png" alt="command_sample" width="50%"/></p>

### Reset Command

The model can be animated by alternately creating and resetting the model.

<p align="center"><img src="https://creativival.github.io/voxelamming/image/reset_command.png" alt="reset_command" width="50%"/></p>

### Float Command

<p align="center"><img src="https://creativival.github.io/voxelamming/image/float_command.png" alt="float_command" width="50%"/></p>

### Push / Pop Matrix

<p align="center"><img src="https://creativival.github.io/voxelamming/image/push_matrix.png" alt="push_matrix" width="50%"/></p>

### Texture

<p align="center"><img src="https://creativival.github.io/voxelamming/image/texture.png" alt="texture" width="50%"/></p>

### Frame Animation

A fluttering butterfly is created by frame animation.

<p align="center"><img src="https://creativival.github.io/voxelamming/image/frame_animation.png" alt="frame_animation" width="50%"/></p>

### User Sharing

TED

## Settings

You can navigate to the settings screen from the 'Settings' button in the top right corner of the screen. Turning off debug mode will disable the display of information on the screen.

## Reset AR World

You can reset the AR world by pressing the 'Reset' button in the top right corner of the screen.

## License

[MIT License](https://github.com/creativival/voxelamming/blob/master/LICENSE)

## Author

creativival

## Contact

[Contact](https://creativival.github.io/voxelamming/contact.en.html)

## Privacy Policy

[Privacy Policy](https://creativival.github.io/voxelamming/privacy.en.html)


