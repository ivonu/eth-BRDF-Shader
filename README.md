# BRDF Shader

## Implemented features:

### Shaders
------------------------------------------------------------------------
Following Shaders are implemented, to model polished steel and hematite:

#### 2. Lambertian Model
------------------------------------------------------------------------
The Lambertian Model just represents diffuse surfaces, and therefor not enough for the two requested materials, because the specular highlights are missing.

#### 3. Phong Lighting Model
------------------------------------------------------------------------
With the Phong Lighting Model, there are some specular highlights, but it doesn't look like steel, because the highlights are not anisotropic.

#### 4. Blinn-Phong Model
------------------------------------------------------------------------
The Blinn-Phong uses instead of the reflected light vector a halfway vector, and therefor hematite looks quite good.

#### 5. Ward's Model
------------------------------------------------------------------------
The Ward's Model is a anisotropic model. Steel looks now more realistic than before.

#### 6. Cook-Torrance Model
------------------------------------------------------------------------
The Cook-Torrance Model is a physics-based reflectance model.

#### 7. Spatially Varying BRDF (SVBRDF)
------------------------------------------------------------------------
To model rusted steel, I added perlin noise to the Cook-Torrance Model.

### Procedural noise
------------------------------------------------------------------------
The following procedural textures are implemented with perlin noise and the Phong Lighting Model

#### A. Wood grain
------------------------------------------------------------------------
A 3D Perlin Noise function is used to model wood grain.

#### B. Marble
------------------------------------------------------------------------
A 3D Perlin Noise function is used to model marbel.

#### C. Earth
------------------------------------------------------------------------
A 3D Perlin Noise function is used to model islands with desserts, clouds and water.
And bump mapping is also implemented with perlin noise.

# Run
To run the framework, you need to start index.html in your browser (recent versions of Firefox and Chrome are supported, don't use IE)
