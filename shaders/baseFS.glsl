precision highp float;
uniform sampler2D u_diffuse;
varying vec2 v_texcoord0;
varying vec3 v_normal;
varying vec3 v_vertex;

void main(void) {

    vec4 color;
    vec4 diffuse;

    // ambient
    float ambientCoefficient = 0.5;

    // diffuse
    diffuse = texture2D(u_diffuse, v_texcoord0);
    float diffuseCoefficient = max(0.0, dot(v_normal, czm_sunDirectionEC));
    //diffuse.xyz *= diffuseCoefficient;

    diffuse.xyz *= min(diffuseCoefficient + ambientCoefficient, 1.0);

    // sum
    vec3 rgb = diffuse.xyz * diffuse.a; // pre multiply alpha
    color = vec4(rgb * czm_lightColor, diffuse.a);
    gl_FragColor = color;
}
