precision highp float;
uniform sampler2D u_ambient;
uniform sampler2D u_diffuse; /* map */
uniform sampler2D u_reflective; /* map */
uniform sampler2D u_bump; /* map */
uniform sampler2D u_specular;
uniform float u_shininess; // this is actually the glossiness factor

varying vec2 v_texcoord0;
varying vec3 v_normal;
varying vec3 v_tangent;
varying vec3 v_bitangent;
varying vec3 v_vertex;

void main(void) {

    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 diffuse;
    vec4 reflection;
    vec4 emission;
    vec4 ambient;
    vec4 specular;
    vec4 normaltex;

    vec4 specularColor = vec4(1.0);
    float specularLevel = 1.0;
    //float reflectionLevel = 0.2;

    // ambient
    float ambientCoefficient = 0.5;

    // diffuse
    diffuse = texture2D(u_diffuse, v_texcoord0);
    float diffuseCoefficient = max(0.0, dot(v_normal, czm_sunDirectionEC));

    diffuse.xyz *= min(diffuseCoefficient + ambientCoefficient, 1.0);

    // specular
    vec3 surfaceToLight = normalize((mat3(czm_view) * czm_sunPositionWC) - v_vertex);
    vec3 surfaceToCamera = normalize(-v_vertex); // we are in Eye Coordinates, so EyePos is (0,0,0)
    vec3 reflected = normalize(-reflect(surfaceToLight, v_normal));

    float specularCoefficient = pow(max(dot(reflected, surfaceToCamera), 0.0), 30.0); // u_shininess is actually the glossiness factor
    specular = specularColor * specularCoefficient * specularLevel;

    // reflection
    //vec3 coord = vec3(mat3(czm_inverseView) * reflect(-surfaceToCamera, normal)) + vec3(1.0, 1.0, 1.0);
    //reflection = texture2D(u_reflective, vec2((coord.x + coord.z) / 4.0, coord.y / -2.0));
    //vec3 coord = normalize(vec3(czm_inverseViewRotation * reflect(surfaceToCamera, v_normal)));
    //reflection = texture2D(u_reflective, vec2(coord.y - coord.x, -(coord.z - coord.y) * 0.33));

    //reflection -= vec4(0.5, 0.5, 0.5, 1.0);
    //reflection *= reflectionLevel;

    float alpha = min(diffuse.a, 1.0);
    //vec3 rgb = (diffuse.xyz + reflection.xyz + specular.xyz) * alpha;
    vec3 rgb = (diffuse.xyz + specular.xyz) * alpha;

    // sum
    color = vec4(rgb * czm_lightColor, alpha);
    //color = vec4(normal.rgb, 1.0);
    //color = vec4(reflection.rgb, 1.0);

    //color = vec4(vec4(coord.z - coord.y, 0.0, 0.0, 1.0));

    gl_FragColor = color;
}
