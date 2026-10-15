# Threat Advisory: Dissecting PWTHOR
### Reverse Engineering an Unauthorized Educational Proxy, Chinese Malware Packer, and OTP-Harvesting Network

**Published by:** CreeD CyberSec Threat Intelligence  
**Author:** CreeD CyberSec (`creedcybersec@gmail.com` | `creedcybersec@proton.me`)  
**Date:** October 15, 2026  
**Status:** Public Security Disclosure / Active Takedown  
**Target Platform:** `pwthor.live` | Android APK (`app_sign.apk`) | `proxy.streamvideo.co.in`  
**Downstream Impact:** Physics Wallah & PenPencil Student Authentication Infrastructure  
**Tracking Ticket:** Physics Wallah Ticket `#17430488`  
**Severity:** HIGH (CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:C/C:H/I:H/A:N - Base Score: 8.8)  

---

## Executive Summary

**PWTHOR** is an unauthorized, pirated educational platform that lures Indian competitive exam students (JEE / NEET / UPSC) with the promise of "Free ₹0 Batches" normally costing thousands of rupees. 

Independent forensic analysis by **CreeD CyberSec** reveals that PWTHOR is not a benign streaming site, but a multi-tiered exploitation network that:
1. Distributes Android binaries packed with **Qihoo 360 Jiagu**—a commercial Chinese packer notorious for obfuscating banking trojans and evading Google Play Protect.
2. Operates an unauthorized reverse-proxy relay (`proxy.streamvideo.co.in` hosted on Heroku) intercepting proprietary PenPencil/Physics Wallah APIs.
3. Actively runs an **OTP-harvesting phishing vector** (`/study/donate-batch`) that convinces students to surrender their login OTPs, effectively hijacking their legitimate accounts to harvest JWT session tokens for unauthorized API pooling.
4. Forces students through multi-stage ad-fraud redirect chains (Tips Guru) generating illicit revenue off student traffic.

Formal legal and security disclosures have been submitted to Physics Wallah / PenPencil Compliance (Ticket `#17430488`) under Sections 43 & 66 of the Indian Information Technology Act, 2000.

---

## Indicators of Compromise (IOCs)

### File Hashes
| File | Format | SHA-256 |
| :--- | :--- | :--- |
| `app_sign.apk` | Android APK | `94a62d438caac7cb68d1da77af421c3c4d7fe7cf74d03ca7ad9bc776f98fe308` |
| `assets/libjiagu.so` | ELF 32-bit | `7c2936746401934c56beee36f0fe78cc9d11059f1406d44558e658baef364d96` |
| `assets/libjiagu_64.so` | ELF 64-bit | `81fecf6c8d197607cb3cb9d479133bb83b0f56a5c13886566d5f7560a0f6e5c1` |
| `assets/.jgapp` | Encrypted DEX | `b154881aeec87b7a5a8f55734293c66f7f3299ea48f9e2b10a08e60ee5a519ee` |

### Network Domains & Infrastructure
| Indicator | Type | Attribution / Role |
| :--- | :--- | :--- |
| `pwthor.live` | FQDN | Web Portal / Phishing Entrypoint (Cloudflare) |
| `proxy.streamvideo.co.in` | FQDN | Unauthorized PenPencil API Proxy (Heroku Router) |
| `streamvideo.co.in` | FQDN | Hostinger Operations, UAB (Rajasthan, India) |
| `studyratna.org` | FQDN | Syndicate Mirror & Downloader |
| `tipsguru.in` | FQDN | Ad-Arbitrage & Multi-Stage Redirect Network |
| `ca-pub-1761832161109324` | AdSense ID | Syndicate Monetization Account |
| `93.127.173.204` | IPv4 | Hostinger Operations UAB (AS47583) |

---

*Full whitepaper and evidence diagrams: See [`README.md`](README.md).*
