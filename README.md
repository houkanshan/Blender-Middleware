# Blender Middleware

We use Blender 2.69, since it still supports 16 color layers (they
were reduced to 8 in 2.70 onwards) and some of our blendfiles use a
lot of color layers for compositing. There might also be backwards
incompatibility issues with some of our viewport rendering addons in
later versions of Blender after the viewport refactor.

## Contents

- Unity template project
  - Editor line/colormap postprocessors
  - Embeddable Blender scripts under `Assets/Blender`
  - Test scene to make sure all features are working

- Blender modules and addons
  - Color data for line primitives
  - Color rendering for lines in the viewport
  - Color compositing using mesh/line color layers
  - 3D gradient coloring tools
  - Line data exporter for Unity
  - Colormap exporter for Unity
  - `krz` python module for programmatic usage of the features above.

- Customized fbx exporter for Blender
  - support for color alpha
  - support for using Export scene, if present in blendfile
  - customized `unity3d_defaults` function (which is called by Unity)

## Installation

1. Download and install Blender 2.69: http://download.blender.org/release/Blender2.69/

   There should only be one instance of blender on your system, so
   that Unity doesn't accidentally use the wrong instance.

2. Run blender, and select File->Save Startup File. This will create a
   user scripts folder on you system for blender addons.

3. Copy the contents of `Blender/2.69` in the repo to your user scripts folder:

   - Mac: `/Users/<username>/Library/Application Support/Blender/2.69`
   - Windows: `\Users\<username>\AppData\Roaming\Blender Foundation\Blender\2.69`

4. We run a modified fbx exporter. Move the `io_scene_fbx` from your
   user scripts folder, located under `2.69/scripts/addons`, to
   Blender's application files, and overwrite the existing files:

   - Mac: `/Applications/blender.app/Contents/MacOS/2.69/scripts/addons`
   - Windows: `C:\Program Files\Blender Foundation\Blender\2.69\scripts\addons`

5. Run Blender again, and open the User Preferences window (File->User Preferences)

6. Run Blender from the terminal/command prompt, so you can see any
   potential errors/warnings that might be generated by the addons or
   export process.

   - On Windows via cmd.exe: `c:\Program Files\Blender Foundation\Blender\blender.exe`
   - On Mac via Terminal.app: `/Applications/blender.app/Contents/MacOS/blender`

7. Under the Addons tab, select the Cardboard category that should now
   be visible on the left. Enable all the addons under this category,
   and click 'Save User Settings'.

8. Open `Unity/Blender-Middleware/Assets/TestScene/Meshes/Test.blend`
   in Blender and save the scene. This should trigger the embedded
   `autoexport.py` script which should rewrite some line files and
   some colormap pngs. Files regenerated under
   `Unity/Blender-Middleware/Assets/TestScene` should be:

   - `Lines/TestBox.lines`
   - `Lines/TestCube.lines`
   - `Textures/TestCubeCol.png`
   - `Textures/TestCubeLinesCol.png`

9. Open the included Unity project in the repo with the latest version
   of Unity. If everything was set up right then there should be no
   errors or warnings during initial import. Check the following in
   the included Test.unity scene:

   - The `Cube` and `Cube_Lines` game objects should appear purple
     (these objects are using colormap textures and should be blended
     halfway between their primary colors and aux colors).

   - The `Box` and `Box_Lines` game objects should be a gradient from
     blue to green from top to bottom (these objects have their
     primary and auxillary colors blended via the uv2 color hack)

   - Right-click on `Lines/TestBox.lines` and select reimport, to make
     sure the lines postprocessor runs without errors/warnings.

   - Right-click on `Textures/TestCubeCol.png` and select reimport, to
     make sure the colormap postprocessor runs without
     errors/warnings.

## Updating

Follow steps 3, 4, 6, 8, and 9.
