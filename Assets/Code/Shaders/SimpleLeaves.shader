Shader "Custom Shaders/SimpleLeaves"
{
    Properties
    {
        _OcclusionScaling("OcclusionScaling", Float) = 1
        [NoScaleOffset]_Diffuse("Diffuse", 2D) = "white" {}
        _Color("Color", Color) = (0.1939237, 0.3773585, 0.1690993, 1)
        _ColorOcclussion("ColorOcclussion", Color) = (0.4780177, 0.6981132, 0.4379672, 1)
        _ColorDown("ColorDown", Color) = (0.08187968, 0.1509434, 0.1274047, 1)
        _ColorVariation("ColorVariation", Color) = (0.8537651, 0.8679245, 0.4544322, 1)
        _WindScale("WindScale", Float) = 1
        _OffsetScale("OffsetScale", Float) = 1
        _WindSpeed("WindSpeed", Float) = 1
        _TreeHeightMod("TreeHeightMod", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
            "DisableBatching"="LODFading"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        AlphaToMask On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float3 _SRPBreaker;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4 = _Color;
            float4 _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4 = _ColorOcclussion;
            float3 _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float((IN.VertexColor.xyz), _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3);
            float _Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float = _OcclusionScaling;
            float3 _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3;
            Unity_Power_float3(_ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3, (_Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float.xxx), _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3);
            float3 _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3;
            Unity_OneMinus_float3(_Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3, _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3);
            float4 _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4, _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4, _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, (_OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3).x);
            float4 _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4 = _ColorDown;
            float _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float;
            Unity_DotProduct_float3(float3(0, 1, 0), IN.WorldSpaceNormal, _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float);
            float _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float;
            Unity_Remap_float(_DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float, float2 (-1, 1), float2 (1, 0), _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4, _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4 = _ColorVariation;
            float4 _Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4 = SHADERGRAPH_OBJECT_POSITION.xxxx;
            float _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float;
            Unity_RandomRange_float((_Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4.xy), float(0), float(0.5), _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            float4 _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4, _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            float4 _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4, _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4);
            surface.BaseColor = (_Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0);
            surface.Occlusion = float(1);
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float3 _SRPBreaker;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4 = _Color;
            float4 _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4 = _ColorOcclussion;
            float3 _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float((IN.VertexColor.xyz), _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3);
            float _Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float = _OcclusionScaling;
            float3 _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3;
            Unity_Power_float3(_ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3, (_Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float.xxx), _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3);
            float3 _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3;
            Unity_OneMinus_float3(_Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3, _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3);
            float4 _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4, _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4, _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, (_OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3).x);
            float4 _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4 = _ColorDown;
            float _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float;
            Unity_DotProduct_float3(float3(0, 1, 0), IN.WorldSpaceNormal, _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float);
            float _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float;
            Unity_Remap_float(_DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float, float2 (-1, 1), float2 (1, 0), _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4, _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4 = _ColorVariation;
            float4 _Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4 = SHADERGRAPH_OBJECT_POSITION.xxxx;
            float _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float;
            Unity_RandomRange_float((_Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4.xy), float(0), float(0.5), _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            float4 _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4, _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            float4 _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4, _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4);
            surface.BaseColor = (_Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0);
            surface.Occlusion = float(1);
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _SRPBreaker;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float3 _SRPBreaker;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float _OffsetScale;
        float _SRPBreaker;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define _ALPHATEST_ON 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float3 _SRPBreaker;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float4 color : INTERP3;
             float3 normalWS : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _SRPBreaker;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4 = _Color;
            float4 _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4 = _ColorOcclussion;
            float3 _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float((IN.VertexColor.xyz), _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3);
            float _Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float = _OcclusionScaling;
            float3 _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3;
            Unity_Power_float3(_ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3, (_Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float.xxx), _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3);
            float3 _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3;
            Unity_OneMinus_float3(_Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3, _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3);
            float4 _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4, _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4, _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, (_OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3).x);
            float4 _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4 = _ColorDown;
            float _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float;
            Unity_DotProduct_float3(float3(0, 1, 0), IN.WorldSpaceNormal, _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float);
            float _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float;
            Unity_Remap_float(_DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float, float2 (-1, 1), float2 (1, 0), _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4, _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4 = _ColorVariation;
            float4 _Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4 = SHADERGRAPH_OBJECT_POSITION.xxxx;
            float _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float;
            Unity_RandomRange_float((_Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4.xy), float(0), float(0.5), _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            float4 _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4, _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            float4 _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4, _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4);
            surface.BaseColor = (_Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float3 _SRPBreaker;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float _OffsetScale;
        float _TreeHeightMod;
        float _OcclusionScaling;
        float3 _SRPBreaker;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4 = _Color;
            float4 _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4 = _ColorOcclussion;
            float3 _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float((IN.VertexColor.xyz), _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3);
            float _Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float = _OcclusionScaling;
            float3 _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3;
            Unity_Power_float3(_ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3, (_Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float.xxx), _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3);
            float3 _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3;
            Unity_OneMinus_float3(_Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3, _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3);
            float4 _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4, _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4, _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, (_OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3).x);
            float4 _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4 = _ColorDown;
            float _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float;
            Unity_DotProduct_float3(float3(0, 1, 0), IN.WorldSpaceNormal, _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float);
            float _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float;
            Unity_Remap_float(_DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float, float2 (-1, 1), float2 (1, 0), _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4, _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4 = _ColorVariation;
            float4 _Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4 = SHADERGRAPH_OBJECT_POSITION.xxxx;
            float _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float;
            Unity_RandomRange_float((_Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4.xy), float(0), float(0.5), _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            float4 _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4, _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            float4 _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4, _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4);
            surface.BaseColor = (_Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4.xyz);
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define _ALPHATEST_ON 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Diffuse_TexelSize;
        float4 _ColorOcclussion;
        float4 _Color;
        float4 _ColorDown;
        float4 _ColorVariation;
        float _WindScale;
        float _WindSpeed;
        float _OffsetScale;
        float3 _SRPBreaker;
        float _TreeHeightMod;
        float _OcclusionScaling;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Diffuse);
        SAMPLER(sampler_Diffuse);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float2 _Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2 = IN.WorldSpacePosition.xz;
            float _Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float = _WindSpeed;
            float _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float;
            Unity_Multiply_float_float(_Property_b2207a66bbdc4d329f25fd8e1826e3be_Out_0_Float, IN.TimeParameters.x, _Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float);
            float _Split_bc61ceae555c4842af6e46b89c711c9b_R_1_Float = IN.ObjectSpacePosition[0];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float = IN.ObjectSpacePosition[1];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_B_3_Float = IN.ObjectSpacePosition[2];
            float _Split_bc61ceae555c4842af6e46b89c711c9b_A_4_Float = 0;
            float _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float = _TreeHeightMod;
            float _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float;
            Unity_Multiply_float_float(_Split_bc61ceae555c4842af6e46b89c711c9b_G_2_Float, _Property_5ecbc47ba40d492588c8fd470d19c175_Out_0_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float);
            float _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float;
            Unity_Subtract_float(_Multiply_42e01f21d7fb418491cf398d92a0cd19_Out_2_Float, _Multiply_2874824384824979b80fff78edfef03f_Out_2_Float, _Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float);
            float2 _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2 = float2(_Subtract_c1f042b177ce482e931b22a28f181f76_Out_2_Float, float(0));
            float2 _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_c1111d11b9bc499eb28f76b60a5af608_Out_1_Vector2, _Vector2_6ca52461a7d143c5a3e9f95c3248de8c_Out_0_Vector2, _Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2);
            float _Property_ab0926857aa548c28df957334518b112_Out_0_Float = _WindScale;
            float _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_9ab2054b38f24a16a81bc2cdfc77579f_Out_2_Vector2, _Property_ab0926857aa548c28df957334518b112_Out_0_Float, _SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float);
            float _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_e1afa364b4f14c6fae3cef0d80ce2697_Out_2_Float, float2 (0, 1), float2 (-1, 1), _Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float);
            float _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float = _OffsetScale;
            float _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float;
            Unity_Multiply_float_float(_Remap_b1ae3cf141f34af6bbefee38bbbae3a6_Out_3_Float, _Property_b0d5952ee1dd4f33b12d6e8a427bb9df_Out_0_Float, _Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float);
            float3 _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            Unity_Add_float3((_Multiply_daf59b8b10e14816bb25c86b984c2b75_Out_2_Float.xxx), IN.ObjectSpacePosition, _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3);
            description.Position = _Add_c5b3399c466b4add8d141677520a3afa_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4 = _Color;
            float4 _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4 = _ColorOcclussion;
            float3 _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float((IN.VertexColor.xyz), _ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3);
            float _Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float = _OcclusionScaling;
            float3 _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3;
            Unity_Power_float3(_ColorspaceConversion_a409520f47194ecaba95d64f25fb9712_Out_1_Vector3, (_Property_3bf4bc79fe1445c69c4b6a87910dade3_Out_0_Float.xxx), _Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3);
            float3 _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3;
            Unity_OneMinus_float3(_Power_0e889b4d92a94e928f09aea84447b1ad_Out_2_Vector3, _OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3);
            float4 _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Property_b311d18fe39246758689283b6ff462b1_Out_0_Vector4, _Property_47dabde071c64652894ffc793964505d_Out_0_Vector4, _Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, (_OneMinus_e278cfd2a9224725951ad8e6d061adf9_Out_1_Vector3).x);
            float4 _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4 = _ColorDown;
            float _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float;
            Unity_DotProduct_float3(float3(0, 1, 0), IN.WorldSpaceNormal, _DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float);
            float _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float;
            Unity_Remap_float(_DotProduct_f806d2efe84147b5a3e1cc1e7aa926b6_Out_2_Float, float2 (-1, 1), float2 (1, 0), _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_7f3adaf03df54f01a534f31cb244d128_Out_2_Vector4, _Property_5c224763ad984cd68e65b9031140f10b_Out_0_Vector4, _Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Remap_2da851316bbc430096f5c3670e7022e8_Out_3_Float);
            float4 _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4 = _ColorVariation;
            float4 _Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4 = SHADERGRAPH_OBJECT_POSITION.xxxx;
            float _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float;
            Unity_RandomRange_float((_Swizzle_2c0b8880c72e42e49b557311bda12d10_Out_1_Vector4.xy), float(0), float(0.5), _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            float4 _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_Blend_c76966d989a6487e843e98d0b610ada8_Out_2_Vector4, _Property_cfbbf935a0f540bfbec7b6a12ba44c2f_Out_0_Vector4, _Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _RandomRange_4d4c858278c843d88eee15a02b6542d5_Out_3_Float);
            UnityTexture2D _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Diffuse);
            float4 _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.tex, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.samplerstate, _Property_11c9b9c486d14941ab9ee9905761439f_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_R_4_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_G_5_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_B_6_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4.a;
            float4 _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Blend_2d5802c083144d838c500ce5ab38ce1c_Out_2_Vector4, _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_RGBA_0_Vector4, _Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4);
            surface.BaseColor = (_Multiply_6b091d6f187f48daadbee809d1328080_Out_2_Vector4.xyz);
            surface.Alpha = _SampleTexture2D_f4c3e8650ea84bafb4417364fd0465bb_A_7_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}