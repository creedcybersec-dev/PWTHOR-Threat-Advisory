/*
   YARA Rule: PWTHOR Qihoo 360 Jiagu Unpacker & Relay Detection
   Author: CreeD CyberSec Threat Intelligence
   Reference: https://github.com/creedcybersec-dev/PWTHOR-Threat-Advisory
   Date: 2026-10-15
   Description: Detects packed APK payloads and dynamic ELF decryptor stubs associated with the PWTHOR piracy & credential harvesting syndicate.
*/

rule PWTHOR_Jiagu_Packer_Stub {
    meta:
        author = "CreeD CyberSec"
        description = "Detects Qihoo 360 Jiagu native decryptor and encrypted DEX archive (.jgapp)"
        severity = "High"
        category = "Trojan / Educational Piracy / Credential Interception"
        sha256 = "94a62d438caac7cb68d1da77af421c3c4d7fe7cf74d03ca7ad9bc776f98fe308"

    strings:
        // Native Shared Objects loaded by Qihoo Jiagu
        $lib1 = "assets/libjiagu.so" ascii
        $lib2 = "assets/libjiagu_64.so" ascii
        $lib3 = "assets/libjiagu_art.so" ascii
        $lib4 = "assets/libjiagu_x86.so" ascii
        
        // Encrypted DEX payload container
        $enc_dex = "assets/.jgapp" ascii
        
        // Characteristic JNI export and stub classes
        $stub_class1 = "com.stub.StubApp" ascii
        $stub_class2 = "com.qihoo.util.StubApp" ascii
        $jni_hook1 = "Java_com_stub_StubApp_attachBaseContext" ascii
        $jni_hook2 = "Java_com_stub_StubApp_onCreate" ascii

    condition:
        uint32(0) == 0x04034b50 and // ZIP file magic (APK)
        ($enc_dex and (1 of ($lib*) or 1 of ($stub_class*)))
}

rule PWTHOR_Proxy_Infrastructure_Artifacts {
    meta:
        author = "CreeD CyberSec"
        description = "Detects decompiled configurations pointing to the PWTHOR Heroku proxy relay"
        severity = "Critical"
        target_domain = "proxy.streamvideo.co.in"

    strings:
        $proxy_url1 = "https://proxy.streamvideo.co.in" ascii wide nocase
        $proxy_url2 = "proxy.streamvideo.co.in/fetch/api.penpencil.co" ascii wide nocase
        $c2_domain1 = "pwthor.live" ascii wide nocase
        $c2_route1  = "/api/direct-fetch-config" ascii wide
        $c2_route2  = "/study/donate-batch" ascii wide
        $ads_pub    = "ca-pub-1761832161109324" ascii wide

    condition:
        2 of them
}
