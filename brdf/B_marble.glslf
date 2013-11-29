// Cook Torrance Fragment Shader
precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

uniform float objectSize;

varying vec3 textureCoordinate;
varying vec3 normal;
varying vec4 position;

vec3 color_dark = vec3(71.0/255.0, 64.0/255.0, 51.0/255.0);
vec3 color_bright = vec3(242.0/255.0, 242.0/255.0, 252.0/255.0);

vec3 mod289(vec3 x) {
    return x - floor(x * (1. / 289.)) * 289.;
}
vec4 mod289(vec4 x) {
    return x - floor(x * (1. / 289.)) * 289.;
}
vec4 permute(vec4 x) {
    return mod289(((x*34.)+1.)*x);
}
vec4 taylorInvSqrt(vec4 r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}
vec3 fade(vec3 t) {
    return t*t*t*(t*(t*6.-15.)+10.);
}

// Classic Perlin noise
// https://github.com/ashima/webgl-noise/
float cnoise(vec3 P) {
    vec3 Pi0 = floor(P); // Integer part for indexing
    vec3 Pi1 = Pi0 + vec3(1.); // Integer part + 1
    Pi0 = mod289(Pi0);
    Pi1 = mod289(Pi1);
    vec3 Pf0 = fract(P); // Fractional part for interpolation
    vec3 Pf1 = Pf0 - vec3(1.); // Fractional part - 1.0
    vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
    vec4 iy = vec4(Pi0.yy, Pi1.yy);
    vec4 iz0 = Pi0.zzzz;
    vec4 iz1 = Pi1.zzzz;

    vec4 ixy = permute(permute(ix) + iy);
    vec4 ixy0 = permute(ixy + iz0);
    vec4 ixy1 = permute(ixy + iz1);

    vec4 gx0 = ixy0 * (1. / 7.);
    vec4 gy0 = fract(floor(gx0) * (1. / 7.)) - 0.5;
    gx0 = fract(gx0);
    vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
    vec4 sz0 = step(gz0, vec4(0.0));
    gx0 -= sz0 * (step(0.0, gx0) - 0.5);
    gy0 -= sz0 * (step(0.0, gy0) - 0.5);

    vec4 gx1 = ixy1 * (1. / 7.);
    vec4 gy1 = fract(floor(gx1) * (1. / 7.)) - 0.5;
    gx1 = fract(gx1);
    vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
    vec4 sz1 = step(gz1, vec4(0.0));
    gx1 -= sz1 * (step(0.0, gx1) - 0.5);
    gy1 -= sz1 * (step(0.0, gy1) - 0.5);

    vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
    vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
    vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
    vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
    vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
    vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
    vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
    vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

    vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
    g000 *= norm0.x;
    g010 *= norm0.y;
    g100 *= norm0.z;
    g110 *= norm0.w;
    vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
    g001 *= norm1.x;
    g011 *= norm1.y;
    g101 *= norm1.z;
    g111 *= norm1.w;

    float n000 = dot(g000, Pf0);
    float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
    float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
    float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
    float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
    float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
    float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
    float n111 = dot(g111, Pf1);

    vec3 fade_xyz = fade(Pf0);
    vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
    vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
    float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x);
    return 2.2 * n_xyz;
}

vec3 getMarbleColor() {

    float scale = 7.0/objectSize;
    float shift = 0.0;
    float x = scale * textureCoordinate.x + shift + 0.0;
    float y = scale * textureCoordinate.y + shift + 0.0;
    float z = scale * textureCoordinate.z + shift + 0.0;

    float frequency = 0.3;
    float amplitude = 5.3;
    float c = 0.;
    for (int i = 0; i < 5; i++) {
        c += amplitude * abs(cnoise (frequency * vec3(x,y,z)));
        amplitude *= 0.55;
        frequency *= 2.;
    }

    c = sin(x + c);
    c = c;

    return mix (color_bright, color_dark, c);
}


void main() {
    vec3 matColor = getMarbleColor();

    // ambient
    vec3 color = globalAmbientLightColor * matColor;

    vec3 normalDirection = normalize(normal);
    vec3 point = position.xyz;

    for (int i = 0; i < 3; i++) {

        vec3 lightDirection = normalize(lightPosition[i]-point); // vector from point to light

        // diffuse
        color += matColor * max(0.0, dot(lightDirection, normalDirection)) * lightColor[i];

        // specular highlights
        if (materialShininess > 0.0) {
            vec3 reflectedDirection = normalize(reflect(-lightDirection, normalDirection)); // vector of reflected light
            vec3 viewDirection = normalize(-point); // vector from point to camera
            color += matColor * pow(max(0.0,dot(reflectedDirection, viewDirection)), materialShininess) * lightColor[i];
        }
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}