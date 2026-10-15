# Dissecting PWTHOR: How an Educational "Free Batch" Network Harvests Student OTPs & Proxies PenPencil Infrastructure

*By CreeD CyberSec Threat Intelligence Desk*  
*Full Technical Advisory & IOC Repository: [github.com/creedcybersec-dev/PWTHOR-Threat-Advisory](https://github.com/creedcybersec-dev/PWTHOR-Threat-Advisory)*

---

### The Hook: The ₹0 "Free Batch" Trap

If you have spent any time in Indian student communities on Telegram, Reddit, or YouTube over the last few months, you’ve probably seen the posts:

> *"Don’t pay ₹6,000 for Lakshya JEE or Yakeen NEET. Download the PWTHOR app or go to pwthor.live — all live classes, test series, and notes for ₹0."*

To a stressed 17-year-old student from a tier-3 town whose family cannot afford expensive coaching, this looks like a miracle. It looks like a noble Robin Hood operation giving away education to the needy.

At **CreeD CyberSec**, we decided to pull the thread. We downloaded their Android binary (`app_sign.apk`), decompiled its bytecode, hooked its network calls in a sandbox, and traced its infrastructure.

What we found wasn't Robin Hood. 

It was a cold, calculated cyber syndication model using **commercial Chinese banking-trojan packers**, **cloud-hosted API proxies**, **active OTP phishing scams**, and **ad-fraud redirect loops** that ultimately gets real students banned from their official accounts while threat actors monetize their credentials.

Here is the full technical dissection.

---

### Phase 1: Unmasking the APK — The Chinese Malware Packer

The threat actors distribute an APK titled `app_sign.apk` (SHA-256: `94a62d438caac7cb68d1da77af421c3c4d7fe7cf74d03ca7ad9bc776f98fe308`).

When you open the APK in a decompiler like JADX or decompress its `classes.dex`, something looks strange: the codebase is virtually empty. There are barely 200 generic framework strings. The entire application logic is hidden.

Looking at the decompressed filesystem, three critical files stand out:
- `assets/libjiagu.so`
- `assets/libjiagu_64.so`
- `assets/.jgapp`

This is **Qihoo 360 Jiagu (360加固)**. 

Qihoo 360 Jiagu is an enterprise-grade commercial Chinese packer originally designed for software protection, but notorious in threat research circles for obfuscating mobile banking trojans and spywares to evade Google Play Protect.

Here is how their cold-bootloader works:
1. When the victim launches the app, Android executes `com.stub.StubApp.attachBaseContext()`.
2. The stub immediately calls JNI native bindings to load `libjiagu.so` into memory.
3. The native code scans `/proc/self/status` to ensure no debugger is attached (`TracerPid == 0`).
4. It reads the encrypted `.jgapp` archive from assets and decrypts the real Dalvik bytecode **directly into volatile RAM**.
5. It invokes Android's `InMemoryDexClassLoader` to register the decrypted classes dynamically, bypassing static heuristic scans.

Why would a "free educational app" need Chinese nation-state-grade memory encryption and anti-debugging? Because it was built to hide its real network telemetry.

---

### Phase 2: The Heroku Man-in-the-Middle Relay

Once the app runs in an instrumented Android emulator with Frida hooks bypassing Jiagu's anti-analysis routines, we intercepted its initial network beacon:

```http
GET https://pwthor.live/api/direct-fetch-config
```

The server returns:
```json
{
  "enabled": true,
  "baseUrl": "https://proxy.streamvideo.co.in/fetch/api.penpencil.co"
}
```

The app does **not** host video files. Instead, it operates an unauthorized reverse proxy hosted at `proxy.streamvideo.co.in`.

When we inspected the HTTP response headers of `proxy.streamvideo.co.in`:
```http
Via: 1.1 heroku-router
Server: Cowboy
X-Powered-By: Express
```

The syndicate is running an Express server inside a **Heroku Dyno container**. The proxy sits between the student and Physics Wallah’s proprietary infrastructure (`api.penpencil.co`). It strips out client headers (`Origin`, `Referer`), injects stolen bearer JWT tokens, requests the live encrypted HLS video chunks from Physics Wallah's CDN, and streams them back to the pirated client.

WHOIS and DNS intelligence on the apex domain `streamvideo.co.in` traced the registrar back to **Hostinger Operations, UAB**, with registrant records localized in **Rajasthan, India**.

---

### Phase 3: The "Donate Batch" Trap (OTP Phishing)

A proxy network this large requires thousands of active, valid subscriber sessions. How does PWTHOR get valid Physics Wallah subscriber accounts without paying for them?

They trick students into surrendering them.

On `https://pwthor.live/study/donate-batch`, the syndicate presents an emotional appeal:
> *"Help poor students who cannot afford courses. Donate your enrolled batch for a noble cause."*

Here is the actual exploit sequence we observed in real-time:
1. A well-meaning student enters their mobile phone number.
2. The PWTHOR backend programmatically makes a real API call to:  
   `POST https://api.penpencil.co/v3/oauth/send-otp`
3. Physics Wallah's automated SMS gateway delivers an authentic OTP to the student’s phone:  
   *"Your Physics Wallah verification code is 492810. Do not share this OTP with anyone."*
4. The student assumes the OTP is just verifying their "donation" and enters it into `pwthor.live`.
5. The PWTHOR backend captures the OTP and submits it to PenPencil:  
   `POST https://api.penpencil.co/v3/oauth/verify-otp`
6. PenPencil returns the student’s permanent `client_token` (JWT Bearer Token) and `refresh_token`.

The student's paid account is now sucked into PWTHOR's proxy pool. When hundreds of users start streaming simultaneously from that single student's session token across different IP ranges, Physics Wallah’s risk engine flags the account for concurrent sharing abuse—and **the student's legitimate account is permanently terminated**.

The student is left with no course, no refund, and a compromised mobile number.

---

### Phase 4: Monetization via Ad-Arbitrage

While students are being stripped of their credentials, the operators are monetizing every single video click through aggressive ad-fraud loops.

Every lecture link forces students through `tipsguru.in`—a domain hooked into **Google AdSense (Publisher ID: `ca-pub-1761832161109324`)**. 

Students are trapped in a 6-tier timer redirect chain that triggers pop-unders, auto-redirects, and forced ad clicks before granting access to the decrypted stream chunk. The syndicate converts stolen educational bandwidth into pure advertising profit.

---

### Responsible Disclosure & Takedown Status

Security research is only complete when defensive action is taken.

On **October 15, 2026 at 04:00 IST**, CreeD CyberSec submitted a comprehensive incident briefing to Physics Wallah Security & Legal Compliance (`compliance@pw.live`, `support@pw.live`), detailing the reverse proxy, the OTP phishing vector, and the Heroku relay.

- **At 09:20 IST on October 15, 2026**, Physics Wallah Support officially registered and escalated the incident under **Ticket #17430488**.
- Abuse notices have also been served to **Hostinger Trust & Safety** (regarding the apex domain `streamvideo.co.in`) and **Heroku Abuse Operations**.
- Formal reports are being submitted to **CERT-In (Indian Computer Emergency Response Team)** under Section 70B of the IT Act.

---

### What You Should Do If You Used PWTHOR

1. **Delete the APK immediately:** If you installed `app_sign.apk`, delete it and run a full device scan.
2. **Revoke all active sessions:** If you ever entered your phone number or OTP on `pwthor.live`, immediately open your official Physics Wallah app -> Go to Profile -> Settings -> **"Log out from all devices"** and reset your password.
3. **Remember the rule of authentication:** **An OTP is a digital key.** You would never give a stranger the physical key to your house so they could "donate your furniture to the poor." Never enter an OTP anywhere except the official application that requested it.

---

### Read the Full Advisory & Detection Signatures

We have open-sourced the complete threat intelligence repository, including:
- High-resolution architecture diagrams and attack flowcharts
- Production YARA hunting rules (`pwthor_jiagu.yar`)
- Suricata / Snort network IDS detection signatures
- Machine-readable IOC datasets (CSV hashes & domains)

🔗 **GitHub Repository:** [https://github.com/creedcybersec-dev/PWTHOR-Threat-Advisory](https://github.com/creedcybersec-dev/PWTHOR-Threat-Advisory)

*Published by CreeD CyberSec Threat Intelligence Group.*  
*Contact: `creedcybersec@gmail.com` | `creedcybersec@proton.me`*
