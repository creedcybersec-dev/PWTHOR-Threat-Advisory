# Coordinated Vulnerability & Threat Disclosure Timeline

**Target Syndicate:** PWTHOR (`pwthor.live`, `proxy.streamvideo.co.in`)  
**Impacted Vendor:** Physics Wallah Pvt. Ltd. / PenPencil Infrastructure  
**Lead Investigator:** CreeD CyberSec Threat Intelligence Group  
**Tracking Ticket:** Physics Wallah Support & Compliance Ticket `#17430488`  
**Hostinger Abuse Ticket:** Incident Ref `HOST-ABUSE-2026-PWTHOR`  

---

### Detailed Incident Timeline (All times in IST - UTC+5:30)

| Timestamp | Event / Forensic Discovery | Action Taken |
| :--- | :--- | :--- |
| **2026-10-14 18:30** | Threat intelligence triage detects mass promotion of "PW Free ₹0 Batches" across Telegram channels targeting Indian students. | Initial sample of `app_sign.apk` acquired from distribution mirror. |
| **2026-10-14 19:15** | Static analysis of `app_sign.apk` initiated using `dexdump` and `apktool`. APK identified as stripped of standard classes. | Discovery of **Qihoo 360 Jiagu** commercial Chinese packer (`libjiagu.so` and `.jgapp`). |
| **2026-10-14 20:45** | Dynamic hooking using Frida / memory dumping reveals in-memory unpacked DEX loading internal API endpoints. | Identified hardcoded fallback routes and obfuscated network requests. |
| **2026-10-14 22:15** | Network traffic interception on live Android emulator intercepts GET request to `https://pwthor.live/api/direct-fetch-config`. | Intercepted JSON configuration: `"baseUrl": "https://proxy.streamvideo.co.in/fetch/api.penpencil.co"`. |
| **2026-10-14 23:30** | Port probe and HTTP header inspection of `proxy.streamvideo.co.in`. | Headers confirm endpoint is hosted on **Heroku Cowboy router** (`Via: 1.1 heroku-router`), relaying unauthenticated requests directly into PenPencil CDN. |
| **2026-10-15 00:15** | Forensic audit of `pwthor.live/study/donate-batch`. | Discovery of OTP phishing mechanism: backend triggers real login SMS from Physics Wallah to victim phone number, captures OTP, and extracts bearer JWT token. |
| **2026-10-15 01:30** | Tracking redirect chains on video click; discovered 6-tier ad-arbitrage loops through `tipsguru.in` with Google AdSense ID `ca-pub-1761832161109324`. | Compiled ad-fraud telemetry dossier. |
| **2026-10-15 04:00** | CreeD CyberSec files emergency security grievance to Physics Wallah Security (`compliance@pw.live`, `grievance.officer@pw.live`, `support@pw.live`). | Delivered full technical disclosure, memory dumps, IOC hashes, and proxy endpoints. |
| **2026-10-15 09:20** | Physics Wallah Customer Escalation & Support Team formally acknowledges receipt. | **Official Case Registered: Ticket #17430488.** Escalated to Engineering / CISO. |
| **2026-10-15 14:00** | Supplementary abuse notification filed with Hostinger Trust & Safety regarding apex domain `streamvideo.co.in` registered in Rajasthan. | Formal request to suspend rogue proxy domain DNS resolution. |
| **2026-10-15 20:58** | Heroku Trust & Abuse team notified regarding active proxy app dyno routing pirated educational traffic. | Submitted dyno headers and Heroku request identifiers. |
| **2026-10-15 21:00** | Coordinated Public Security Advisory published by CreeD CyberSec to warn students against surrendering OTPs. | Advisory pushed live on GitHub and CreeD CyberSec intelligence portal. |

---

*CreeD CyberSec strictly adheres to ethical coordinated vulnerability disclosure principles. No unpatched zero-day vulnerabilities in upstream vendor infrastructure are disclosed without prior vendor coordination.*
