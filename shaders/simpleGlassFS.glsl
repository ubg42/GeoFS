precision highp float;
uniform vec4 u_diffuse;
uniform float u_shininess;
uniform float u_transparency;

varying vec3 v_normal;
varying vec3 v_vertex;

void main(void) {
    vec4 color;
    vec4 specular;

    // specular
    vec3 surfaceToLight = normalize((mat3(czm_view) * czm_sunPositionWC) - v_vertex);
    vec3 surfaceToCamera = normalize(-v_vertex); // we are in Eye Coordinates, so EyePos is (0,0,0)
    vec3 reflected = normalize(-reflect(surfaceToLight, v_normal));

    float specularCoefficient = pow(max(dot(reflected, surfaceToCamera), 0.0), u_shininess);

    specular = vec4(1.0) * specularCoefficient;

    // sum
    vec3 rgb = (u_diffuse.xyz + specular.xyz) * u_transparency;
    color = vec4(rgb * czm_lightColor, u_transparency);

    gl_FragColor = color;
}
