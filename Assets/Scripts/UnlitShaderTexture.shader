// This shader draws a texture on the mesh.
Shader "Example/URPUnlitShaderTexture"
{
    // The _BaseMap variable is visible in the Material's Inspector, as a field
    // called Base Map.
    Properties
    { 
        _BaseMap("Base Map", 2D) = "white"
    }

    SubShader
    {
        Tags {  "RenderPipeline" = "UniversalRenderPipeline" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

            struct Attributes
            {
                float4 positionOS   : POSITION;
                // The uv variable contains the UV coordinate on the texture for the
                // given vertex.
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                // The uv variable contains the UV coordinate on the texture for the
                // given vertex.
                float2 uv           : TEXCOORD0;
            };

            // This macro declares _BaseMap as a Texture2D object.
            TEXTURE2D(_BaseMap);
            // This macro declares the sampler for the _BaseMap texture.
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                // The following line declares the _BaseMap_ST variable, so that you
                // can use the _BaseMap variable in the fragment shader. The _ST 
                // suffix is necessary for the tiling and offset function to work.
                float4 _BaseMap_ST;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                // The TRANSFORM_TEX macro performs the tiling and offset
                // transformation.
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // The SAMPLE_TEXTURE2D marco samples the texture with the given
                // sampler.

                float2 uv = IN.uv;
                half4 color;

                int n_gores = 18;

                float x = uv[0], y = uv[1];
                // Normally, the formulas are the following:
                // x = (lambda - lambda_0) * cos(psi)
                // y = psi
                // Where:
                //   - lambda is the longitude
                //   - lambda_0 is longitude of the central meridian
                //   - psi is the latitude

                // But we already have x and y, so we need to find the lambda and psi
                // to sample from

                int gore_number = (int) floor(x * n_gores);
                float x_offset = (gore_number + 0.5) / (float)n_gores;

                float psi = (y - 0.5) * PI;  // Ranges from -pi/2 to pi/2
                float lambda = (x - x_offset) / cos(psi) + x_offset;
                uv[0] = lambda;
                // uv[1] = psi / PI + 0.5;

                // Check that the resulting lambda is a valid one
                // Indeed, when we take psi and lambda values from their ranges,
                // some x values are not possible
                if (0 < lambda - gore_number / (float)n_gores
                    && lambda - gore_number / (float)n_gores < 1 / (float) n_gores)
                {
                    color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
                }
                else
                {
                    color = 0;
                }
                return color;
            }
            ENDHLSL
        }
    }
}