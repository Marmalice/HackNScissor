Shader "CustomShaders/VATShaderPatched"
{
    Properties
    {
        [NoScaleOffset]_openVAT_main("openVAT_main", 2D) = "white" {}
        [NoScaleOffset]_openVAT_nrml("openVAT_nrml", 2D) = "white" {}
        _minValues("minValues", Vector) = (0, 0, 0, 0)
        _maxValues("maxValues", Vector) = (0, 0, 0, 0)
        _speed("speed", Float) = 1
        _frame("frame", Float) = 0
        _frames("frames", Float) = 0
        _exaggeration("exaggeration", Float) = 0
        _resolutionY("resolutionY", Float) = 0
        _Basecolor("Basecolor", Color) = (0, 0, 0, 0)
        _Metallic("Metallic", Float) = 0
        _Smoothness("Smoothness", Float) = 0
        [NoScaleOffset]_Texture2D("Texture2D", 2D) = "white" {}
        [ToggleUI]_UseTIme("UseTIme", Float) = 1
        [ToggleUI]_UsePackedNormals("UsePackedNormals", Float) = 1
        _Scale("Scale", Float) = 10
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 1
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
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
            "Queue"="Geometry"
            "DisableBatching"="False"
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
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
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
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
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
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        float SRPBreaker;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            float4 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4;
            float3 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3;
            float2 _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2;
            Unity_Combine_float(_Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3, _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2);
            float _Property_da361d3edc364694aa6250c27714498c_Out_0_Float = _Metallic;
            float _Property_d72aa655fac34feb915c1727170fa233_Out_0_Float = _Smoothness;
            surface.BaseColor = (_Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Property_da361d3edc364694aa6250c27714498c_Out_0_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Property_d72aa655fac34feb915c1727170fa233_Out_0_Float;
            surface.Occlusion = float(1);
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
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
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
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
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        float SRPBreaker;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            float4 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4;
            float3 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3;
            float2 _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2;
            Unity_Combine_float(_Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3, _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2);
            float _Property_da361d3edc364694aa6250c27714498c_Out_0_Float = _Metallic;
            float _Property_d72aa655fac34feb915c1727170fa233_Out_0_Float = _Smoothness;
            surface.BaseColor = (_Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Property_da361d3edc364694aa6250c27714498c_Out_0_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Property_d72aa655fac34feb915c1727170fa233_Out_0_Float;
            surface.Occlusion = float(1);
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        float SRPBreaker;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
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
            output.tangentWS.xyzw = input.tangentWS;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
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
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        float SRPBreaker;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            float4 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4;
            float3 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3;
            float2 _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2;
            Unity_Combine_float(_Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3, _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2);
            surface.BaseColor = (_Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
        
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            float4 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4;
            float3 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3;
            float2 _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2;
            Unity_Combine_float(_Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3, _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2);
            surface.BaseColor = (_Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4.xyz);
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
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
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv2;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float4 _openVAT_main_TexelSize;
        float4 _openVAT_nrml_TexelSize;
        float3 _minValues;
        float3 _maxValues;
        float _frame;
        float _resolutionY;
        float _frames;
        float _speed;
        float4 _Basecolor;
        float _Metallic;
        float _Smoothness;
        float _exaggeration;
        float4 _Texture2D_TexelSize;
        float _UseTIme;
        float _UsePackedNormals;
        float _Scale;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_openVAT_main);
        SAMPLER(sampler_openVAT_main);
        TEXTURE2D(_openVAT_nrml);
        SAMPLER(sampler_openVAT_nrml);
        TEXTURE2D(_Texture2D);
        SAMPLER(sampler_Texture2D);
        
        // Graph Includes
        // GraphIncludes: <None>
        
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
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        struct Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float
        {
        };
        
        void SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float(float3 _colorinput, float _isNormal, float3 _minValues, float3 _maxValues, Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float IN, out float3 New_0)
        {
        float3 _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3 = _colorinput;
        float _Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[0];
        float _Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[1];
        float _Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float = _Property_17cd7f9679734d9ca32b7d5c509929f7_Out_0_Vector3[2];
        float _Split_62508ed163bd4e1e9ef14095565560c1_A_4_Float = 0;
        float _Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean = _isNormal;
        float2 _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2 = float2(float(-1), float(1));
        float3 _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3 = _minValues;
        float _Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[0];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[1];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float = _Property_6b0796f7d7224294af5d179ffd58c258_Out_0_Vector3[2];
        float _Split_7de939ebfcd040a597a985d73b78b6cd_A_4_Float = 0;
        float3 _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3 = _maxValues;
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[0];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[1];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float = _Property_e1a0daf0a6cc448894c32f578dec1951_Out_0_Vector3[2];
        float _Split_f4b75f81f9fd47ddb011698b19a33e59_A_4_Float = 0;
        float2 _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_R_1_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_R_1_Float);
        float2 _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2;
        Unity_Branch_float2(_Property_efcd1f7ee12047d3b32a721298f393c5_Out_0_Boolean, _Vector2_3fbe51676d774b13b2c3699a884d8006_Out_0_Vector2, _Vector2_b5fd38413c724a27b4361077168d09f9_Out_0_Vector2, _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2);
        float _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_R_1_Float, float2 (0, 1), _Branch_ae7a6de1417f4077ad4b7448c3b7ce5f_Out_3_Vector2, _Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float);
        float _Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean = _isNormal;
        float2 _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_G_2_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_G_2_Float);
        float2 _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2;
        Unity_Branch_float2(_Property_997eb41b1a924cff88f4134979e92c4c_Out_0_Boolean, _Vector2_7b364fe8d36c44f69d7024f1167c6bd3_Out_0_Vector2, _Vector2_c6b28d1a400647a38821d580f75c26a1_Out_0_Vector2, _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2);
        float _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_G_2_Float, float2 (0, 1), _Branch_50e8e0f2a46243e1944d41c90ebfcb19_Out_3_Vector2, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float);
        float _Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean = _isNormal;
        float2 _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2 = float2(float(-1), float(1));
        float2 _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2 = float2(_Split_7de939ebfcd040a597a985d73b78b6cd_B_3_Float, _Split_f4b75f81f9fd47ddb011698b19a33e59_B_3_Float);
        float2 _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2;
        Unity_Branch_float2(_Property_772930ef3aef459bb9eed701b6d44288_Out_0_Boolean, _Vector2_626307c9bba148de8ff840a8f5530803_Out_0_Vector2, _Vector2_e8c0b82565d140d79d3dbfadd3542599_Out_0_Vector2, _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2);
        float _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float;
        Unity_Remap_float(_Split_62508ed163bd4e1e9ef14095565560c1_B_3_Float, float2 (0, 1), _Branch_5b0ee08706f942f497cb7a36a648820e_Out_3_Vector2, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float);
        float4 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4;
        float3 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3;
        float2 _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2;
        Unity_Combine_float(_Remap_12483e3e780941ddaa625c4cec5c9810_Out_3_Float, _Remap_504058aba9d54af2a0a90e8e701c7605_Out_3_Float, _Remap_6bd6ef006ccc43409c04390020664836_Out_3_Float, float(0), _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGBA_4_Vector4, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, _Combine_c10c9a1aa7d14c3da3b791da8738837c_RG_6_Vector2);
        float3 _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_c10c9a1aa7d14c3da3b791da8738837c_RGB_5_Vector3, float3(0.01, 0.01, 0.01), _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3);
        New_0 = _Multiply_bfa5f5b1165143b9ba5a66431eeb9e63_Out_2_Vector3;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float
        {
        float3 ObjectSpacePosition;
        half4 uv2;
        float3 TimeParameters;
        };
        
        void SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(UnityTexture2D _openVAT_main, UnityTexture2D _openVAT_nrml, float3 _minValues, float3 _maxValues, float _frame, float _frames, float _exaggeration, float _Y_resolution, float _UsePackedNormals, float _UseTime, float _speed, Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float IN, out float3 OutVector3_1, out float3 OutVector31_2)
        {
        float _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float = _exaggeration;
        float _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float;
        Unity_Add_float(float(1), _Property_7ad33e32bb7f4be0b45bd00304009de2_Out_0_Float, _Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float);
        UnityTexture2D _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D = _openVAT_main;
        float4 _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4 = IN.uv2;
        float _Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[0];
        float _Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[1];
        float _Split_41f9926cb00c4d828f267180a1d68e50_B_3_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[2];
        float _Split_41f9926cb00c4d828f267180a1d68e50_A_4_Float = _UV_e0b2ce41b7ef43a59e56fc452352c0ff_Out_0_Vector4[3];
        float _Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean = _UseTime;
        float _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float;
        Unity_Multiply_float_float(IN.TimeParameters.x, 30, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float);
        float _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float = _frame;
        float _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Multiply_0030362d1742480b90d483fc5cc68174_Out_2_Float, _Property_e5ec8bb01e0d41ada4ae92a5966a18fe_Out_0_Float, _Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float);
        float _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float = _speed;
        float _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float;
        Unity_Branch_float(_Property_587413df677b435e80fbb82a93bc77c2_Out_0_Boolean, _Property_81ea322e1abb4f93aa9451179a30f7c7_Out_0_Float, float(1), _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float);
        float _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float;
        Unity_Multiply_float_float(_Branch_6c1af502c4dc473abfc0f89fe116c22f_Out_3_Float, _Branch_06e2533bdc7e468c8b7387e27bbb7101_Out_3_Float, _Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float);
        float _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float = _frames;
        float _Divide_c353959870254445a7712f0accb4502b_Out_2_Float;
        Unity_Divide_float(_Multiply_f3e319da07e84e20b40020582ded1860_Out_2_Float, _Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, _Divide_c353959870254445a7712f0accb4502b_Out_2_Float);
        float _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float;
        Unity_Fraction_float(_Divide_c353959870254445a7712f0accb4502b_Out_2_Float, _Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float);
        float _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float;
        Unity_Subtract_float(_Property_b4fade0d5574423abca423b55142f07d_Out_0_Float, float(1), _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float);
        float _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float;
        Unity_Multiply_float_float(_Fraction_d71f4ddf7e9844b8a552475807601cef_Out_1_Float, _Subtract_190c9e1085094add9db6e63fc030a281_Out_2_Float, _Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float);
        float _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float = _Y_resolution;
        float _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f8720ca07af9462b98b8b3e908d73769_Out_0_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float);
        float _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_13189dba03164b9aaed211f3bbe5b910_Out_2_Float, _Divide_ff4550c7a6ce4688b20f95f0f532c0a1_Out_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float);
        float _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float;
        Unity_Subtract_float(_Split_41f9926cb00c4d828f267180a1d68e50_G_2_Float, _Multiply_9e7a24803468411e841b52e1102ad947_Out_2_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float);
        float4 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4;
        float3 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3;
        float2 _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(0), float(0), _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGBA_4_Vector4, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RGB_5_Vector3, _Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2);
          float4 _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_R_5_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_G_6_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_B_7_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_A_8_Float = _SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.a;
        float3 _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3 = _minValues;
        float3 _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3 = _maxValues;
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3;
        half3 _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_SampleTexture2DLOD_63181d4dad8d4d9aafbd0ca9aef6300b_RGBA_0_Vector4.xyz), 0, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3, _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3);
        float3 _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Add_8ecbc38af3af4efb846e4516012d2780_Out_2_Float.xxx), _openVATrangeCalculation_e05713f1334547b5823f82fc64a429e3_New_0_Vector3, _Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3);
        float3 _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        Unity_Add_float3(_Multiply_3667fa69ff72490fb5a041a73b918d39_Out_2_Vector3, IN.ObjectSpacePosition, _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3);
        float _Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean = _UsePackedNormals;
        float _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float;
        Unity_Add_float(_Subtract_4e834cf75ce24b86ba59ddee9b6cda98_Out_2_Float, float(-0.5), _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float);
        float4 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4;
        float3 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3;
        float2 _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2;
        Unity_Combine_float(_Split_41f9926cb00c4d828f267180a1d68e50_R_1_Float, _Add_1a94d5b419f741d591efdd91bd3b2247_Out_2_Float, float(0), float(0), _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGBA_4_Vector4, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RGB_5_Vector3, _Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2);
          float4 _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.tex, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.samplerstate, _Property_e7af5fe02e39486787b83f370dd3869e_Out_0_Texture2D.GetTransformedUV(_Combine_b8f6dbc13a144ed5b8a8b82c328883b9_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_R_5_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_G_6_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_B_7_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_A_8_Float = _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4.a;
        UnityTexture2D _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D = _openVAT_nrml;
          float4 _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.tex, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.samplerstate, _Property_e1d07625f3894f318b4d85bc0ecb3234_Out_0_Texture2D.GetTransformedUV(_Combine_8e10d22745dd4eb1a4f4518bbf6a4c98_RG_6_Vector2), float(0));
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_R_5_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_G_6_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_B_7_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_A_8_Float = _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4.a;
        float4 _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4;
        Unity_Branch_float4(_Property_b23a48f4ac1f4239ab44785923670b79_Out_0_Boolean, _SampleTexture2DLOD_dde40d39ecce4702bd385f756fb47d89_RGBA_0_Vector4, _SampleTexture2DLOD_3e82387e0e61490fa64b543a8b6ca707_RGBA_0_Vector4, _Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4);
        Bindings_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9;
        half3 _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3;
        SG_openVATrangeCalculation_e9f5bf2c7b1060149b89ae1190f5be92_float((_Branch_001a510d46094390b01ee68870a3f1e8_Out_3_Vector4.xyz), 1, _Property_8c1236f4a8464f7299a7c24105672d08_Out_0_Vector3, _Property_4a6e3612e04140c8b1734ec50610fee0_Out_0_Vector3, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9, _openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3);
        float3 _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
        Unity_Multiply_float3_float3(_openVATrangeCalculation_ca91f91ee95445039ecaa46769aaa0a9_New_0_Vector3, float3(-1, 1, 1), _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3);
        OutVector3_1 = _Add_d43e84ddd0e5427c96adcee5548aeb47_Out_2_Vector3;
        OutVector31_2 = _Multiply_05b6e2c3cb334a06aaaf0519a8368b04_Out_2_Vector3;
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
            UnityTexture2D _Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_main);
            UnityTexture2D _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_openVAT_nrml);
            float3 _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3 = _minValues;
            float3 _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3 = _maxValues;
            float2 _Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2 = SHADERGRAPH_OBJECT_POSITION.xz;
            float _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_1e56158e43eb49c7afc0a0e6d93607f1_Out_1_Vector2, float(0), float(1), _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float);
            float _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float;
            Unity_Add_float(IN.TimeParameters.x, _RandomRange_bfb1227566994150ac86f43f1e1c2635_Out_3_Float, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float);
            float _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float;
            Unity_Multiply_float_float(30, _Add_747340b363eb483b9bded2a11c18257d_Out_2_Float, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float);
            float _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float = _frames;
            float _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float = _exaggeration;
            float _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float = _resolutionY;
            float _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean = _UsePackedNormals;
            float _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean = _UseTIme;
            float _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float = _speed;
            Bindings_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float _openVATstandard_e00a52cd2341478c8548244b1e49f546;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.ObjectSpacePosition = IN.ObjectSpacePosition;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.uv2 = IN.uv2;
            _openVATstandard_e00a52cd2341478c8548244b1e49f546.TimeParameters = IN.TimeParameters;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            float3 _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
            SG_openVATstandard_6d49bb66d28276b48b0178de5ea9c7e0_float(_Property_61f54a6c8fa641a4b58c9dde0884a5f3_Out_0_Texture2D, _Property_7514c9d9f0ee4e3f9874d18c0972db5c_Out_0_Texture2D, _Property_00ce487c6aed49a0bcebddd42b8ae218_Out_0_Vector3, _Property_f0dc722a1aae4d3fb4afe8ab0b0eb26e_Out_0_Vector3, _Multiply_40c4a0ca88db41c1abd78db529cce8c5_Out_2_Float, _Property_a13a35906d7441debf33dca4c636e430_Out_0_Float, _Property_97c938d6df034641967f48dfe6c7e845_Out_0_Float, _Property_4cfe0de21d7d4dad85270eb6a052f87c_Out_0_Float, _Property_9dd0ebc79b5e4103852218dcb3e7ece7_Out_0_Boolean, _Property_79e624b413284c17a9ef2bc54dcb489c_Out_0_Boolean, _Property_b47c0908cd8e4a16858246e6fe929336_Out_0_Float, _openVATstandard_e00a52cd2341478c8548244b1e49f546, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3, _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3);
            description.Position = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector3_1_Vector3;
            description.Normal = _openVATstandard_e00a52cd2341478c8548244b1e49f546_OutVector31_2_Vector3;
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
            float4 _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4 = _Basecolor;
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[0];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[1];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[2];
            float _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float = _Property_5a5849100c794606bc0aab125de929b9_Out_0_Vector4[3];
            float4 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4;
            float3 _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3;
            float2 _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2;
            Unity_Combine_float(_Split_189468af1a5a453f9fa97e826ca7f6b0_R_1_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_G_2_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_B_3_Float, _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4, _Combine_c0dde5a027534dcba8013d669fd15fa0_RGB_5_Vector3, _Combine_c0dde5a027534dcba8013d669fd15fa0_RG_6_Vector2);
            surface.BaseColor = (_Combine_c0dde5a027534dcba8013d669fd15fa0_RGBA_4_Vector4.xyz);
            surface.Alpha = _Split_189468af1a5a453f9fa97e826ca7f6b0_A_4_Float;
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
            output.uv2 =                                        input.uv2;
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