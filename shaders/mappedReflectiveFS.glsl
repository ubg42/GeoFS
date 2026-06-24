precision highp float;
uniform sampler2D u_ambient;
uniform sampler2D u_diffuse;
uniform sampler2D u_reflective;
uniform sampler2D u_bump;
uniform sampler2D u_specular;
uniform float u_shininess;
uniform vec4 u_emission;

varying vec4 v_specularColor;
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


    vec4 speculartex = texture2D(u_specular, v_texcoord0);
    float specularTexLevel = speculartex.r;

    float specularLevel = specularTexLevel * (1.0 + u_emission.x); // use GLTF emission color as specular multiplier
    float reflectionLevel = 0.4 * specularTexLevel * (1.0 + u_emission.y); // use GLTF emission color as reflection multiplier

    mat3 tangentToEye = czm_tangentToEyeSpaceMatrix(v_normal, v_tangent, v_bitangent);
    normaltex = texture2D(u_bump, v_texcoord0);
    vec3 normal = tangentToEye * normalize(2.0 * normaltex.rgb - 1.0);

    // ambient
    float ambientCoefficient = 0.3;
    //ambient = texture2D(u_ambient, v_texcoord0) * ambientCoefficient;

    // diffuse
    diffuse = texture2D(u_diffuse, v_texcoord0);
    float diffuseCoefficient = max(0.0, dot(normal, czm_sunDirectionEC) * 2.0);
    //diffuse.xyz *= diffuseCoefficient;

    diffuse.xyz *= min(diffuseCoefficient + ambientCoefficient, 1.0);

    // specular
    vec3 surfaceToLight = normalize((mat3(czm_view) * czm_sunPositionWC) - v_vertex);
    vec3 surfaceToCamera = normalize(-v_vertex); // we are in Eye Coordinates, so EyePos is (0,0,0)
    vec3 reflected = normalize(-reflect(surfaceToLight, normal));

    float specularCoefficient = pow(max(dot(reflected, surfaceToCamera), 0.0), u_shininess);
    specular = vec4(czm_lightColor, 1.0) * specularCoefficient * specularLevel;

    // reflection
    //vec3 coord = vec3(mat3(czm_inverseView) * reflect(-surfaceToCamera, normal)) + vec3(1.0, 1.0, 1.0);
    //reflection = texture2D(u_reflective, vec2((coord.x + coord.z) / 4.0, coord.y / -2.0));
    vec3 coord = normalize(vec3(czm_inverseViewRotation * reflect(surfaceToCamera, normal)));
    reflection = texture2D(u_reflective, vec2(coord.y - coord.x, -(coord.z - coord.y) / 3.0));

    //reflection -= vec4(0.5, 0.5, 0.5, 1.0);
    reflection *= reflectionLevel;

    float alpha = min(diffuse.a, 1.0);
    vec3 rgb = (diffuse.xyz + reflection.xyz + specular.xyz) * alpha;

    // sum
    color = vec4(rgb * czm_lightColor, alpha);
    //color = vec4(normal.rgb, 1.0);
    //color = vec4(reflection.rgb, 1.0);

    //color = vec4(vec4(coord.z - coord.y, 0.0, 0.0, 1.0));

    gl_FragColor = color;
}
