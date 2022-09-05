# MoonLamp

Transform an image into an interrupted sinusoidal projection, for a DIY 3D globe of the moon or any other celestial body.

Input:
![moon-equi-small](https://user-images.githubusercontent.com/8348534/188509428-728c6cf9-ae6d-4d00-a0e7-df20856aac83.png)

Output:
![screenshot-small](https://user-images.githubusercontent.com/8348534/188511200-4bc752fc-07a2-4ef5-abd8-466058000f68.png)

(Note: the images have been scaled down, but are actually 8k)

## Usage
No need to press play, just select the main camera in the scene hierarchy, and take a screenshot using the menu "Custom" -> "Render camera to file".
The output file is in Assets/screenshot.png.


## Changing the image
1. Find the high-res image of a planet in equirectangular projection (8192x4096 resolution is good).
   For the moon: https://svs.gsfc.nasa.gov/cgi-bin/details.cgi?aid=4720
2. Add the image as an asset, change the "Default" configuration on that texture:
   - Max Size: 8192
   - Compression: None
3. Change the texture on the Materials/MapMaterial.map; the display should change to an interrupted sinusoidal projection.


## Improving
The project uses Universal Rendering Pipeline (URP) but all the calculation is done in a texture shader under Assets/Scripts/UnlitShaderTexture.shader.
For each uv (basically each output pixel), it samples the pixel value using the associated latitude and longitude from the original picture.
The number of gores (the vertical petals) can be changed in that shader.

Reference: https://en.wikipedia.org/wiki/Sinusoidal_projection
