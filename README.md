# Blender Middleware

We use Blender 2.69, since it still supports 16 color layers (they
were reduced to 8 in 2.70 onwards) and some of our blendfiles use a
lot of color layers for compositing. There might also be backwards
incompatibility issues with some of our viewport rendering addons in
later versions of Blender after the viewport refactor.

## Contents

- Unity template project, under `Unity`
  - Editor line/colormap postprocessors
  - Embeddable Blender scripts under `Assets/Blender`
  - Test scene to make sure all features are working

- Blender modules and addons, under `Blender`
  - Color data for line primitives
  - Color rendering for lines in the viewport
  - Color compositing using mesh/line color layers
  - 3D gradient coloring tools
  - improved vertex color painting tool
  - Line data exporter for Unity
  - Colormap exporter for Unity
  - `cc` python module for programmatic usage of the features above.

- Customized fbx exporter for Blender (monkeypatches existing io_scene_fbx addon)
  - support for color alpha
  - support for using Export scene, if present in blendfile
  - customized `unity3d_defaults` function (which is called by Unity)

## Installation

1. Download and install Blender 2.69: http://download.blender.org/release/Blender2.69/

   There should only be one instance of blender on your system, so
   that Unity doesn't accidentally use the wrong instance.

2. Create a `sync.config` file in the repository root, and define
   `BLENDER_USER_PATH` which should point to the user scripts
   path. This is typically:

   - `/Users/<user>/AppData/Roaming/Blender Foundation/Blender` on win
   - `/Users/<user>/Library/Application Support/Blender` on mac
   - `<home>/.config/blender` on linux

   See `sync.config.example`.

3. Run the `./update-system.sh` shell script in the terminal (WSL on
   Windows). This will copy addon/startup files into the user scripts
   path. Note: this will overwrite the userprefs/startup.blend file so
   that the addons are enabled automatically.

4. Run Blender from the terminal/command prompt, so you can see any
   potential errors/warnings that might be generated by the addons or
   export process.

   - On Mac via Terminal.app: `/Applications/blender.app/Contents/MacOS/blender`
   - On Win via cmd.exe: `C:\Program Files\Blender Foundation\Blender\blender.exe`

5. Open `Unity/Blender-Middleware/Assets/TestScene/Meshes/Test.blend`
   in Blender and save the scene. This should trigger the embedded
   `autoexport.py` script which should rewrite some line files and
   some colormap pngs. Files regenerated under
   `Unity/Blender-Middleware/Assets/TestScene` should be:

   - `Lines/TestBox.lines`
   - `Lines/TestCube.lines`
   - `Textures/TestCubeCol.png`
   - `Textures/TestCubeLinesCol.png`

   Check the console output for any saving/export related errors.

6. Open the included Unity project in the repo with the latest version
   of Unity. If everything was set up right then there should be no
   errors or warnings during initial import. Check the following in
   the included Test.unity scene:

   - The `Cube` and `Cube_Lines` game objects should appear purple
     (these objects are using colormap textures and should be blended
     halfway between their primary colors and aux colors).

   - The `Box` and `Box_Lines` game objects should be a gradient from
     blue to green from top to bottom (these objects have their
     primary and aux colors blended via our homebrew secondary color
     hack via `Mesh.uv2`).

   - Right-click on `Lines/TestBox.lines` and select reimport, to make
     sure the lines postprocessor runs without errors/warnings.

   - Right-click on `Textures/TestCubeCol.png` and select reimport, to
     make sure the colormap postprocessor runs without
     errors/warnings.

   If there aren't any errors/warnings at this point, the middleware
   should be working ok.

## Updating

Follow step 3-6 and make sure there aren't any warnings or errors in
both the system and Unity's console/terminal.
