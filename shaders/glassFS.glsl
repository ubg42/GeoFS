precision highp float;
uniform vec4 u_diffuse;
uniform sampler2D u_reflective;
uniform float u_shininess;
uniform float u_transparency;

varying vec3 v_normal;
varying vec3 v_vertex;

void main(void) {

    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 diffuse;
    vec4 reflection;
    vec4 emission;
    vec4 ambient;
    vec4 specular;

    // ambient
    float ambientCoefficient = 0.5;

    // diffuse
    diffuse = u_diffuse;
    float diffuseCoefficient = max(0.0, dot(v_normal, czm_sunDirectionEC));

    diffuse.xyz *= min(diffuseCoefficient + ambientCoefficient, 1.0);

    // specular and reflection
    vec3 surfaceToCamera = normalize(-v_vertex); // we are in Eye Coordinates, so EyePos is (0,0,0)

    // specular only
    vec3 surfaceToLight = normalize((mat3(czm_view) * czm_sunPositionWC) - v_vertex);
    vec3 reflected = normalize(-reflect(surfaceToLight, v_normal));
    float specularCoefficient = pow(max(dot(reflected, surfaceToCamera), 0.0), u_shininess);
    specular = vec4(1.0) * specularCoefficient;

    // reflection
    vec3 coord = (normalize(mat3(czm_inverseView) * reflect(surfaceToCamera, v_normal)) + vec3(1., 1., 1.)) * 0.5;
    reflection = texture2D(u_reflective, vec2(coord.y, coord.x));

    float reflectionCoefficient = u_shininess * 0.01;

    float alpha = min(max(u_transparency, length(reflection.xyz) * reflectionCoefficient), 1.0);

    reflection -= vec4(0.5, 0.5, 0.5, 1.0);
    reflection *= reflectionCoefficient;

    // sum
    // !! Premultiplied Alpha !!
    vec3 rgb = (diffuse.xyz + reflection.xyz + specular.xyz) * alpha;

    color = vec4(rgb * czm_lightColor, alpha);
    gl_FragColor = color;
}
