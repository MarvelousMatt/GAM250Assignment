﻿Shader "Custom/DissolveByMap" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_NoiseMap ("Noise Map", 2D) = "white" {}

		_AmountOfDissolve("Amount of dissolve", Range(0,1)) = 0
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NoiseMap;
		float _AmountOfDissolve;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NoiseMap;
			float2 uv_BumpMap;
		};


		void surf (Input IN, inout SurfaceOutputStandard o) {

			float brightnessOfPixel = 0;
			
			//Get the brightness of the current pixel by multiplying the r,g and b values of the noise map by predefined values
			brightnessOfPixel += tex2D(_NoiseMap, IN.uv_NoiseMap).r * 0.375;
			brightnessOfPixel += tex2D(_NoiseMap, IN.uv_NoiseMap).g * 0.5;
			brightnessOfPixel += tex2D(_NoiseMap, IN.uv_NoiseMap).b * 0.125;
			
			//If the brightness of this pixel isn't more than the dissolve threshold we clip it
			clip((brightnessOfPixel - _AmountOfDissolve));


			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
