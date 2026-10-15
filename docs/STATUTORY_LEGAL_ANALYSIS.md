# Statutory & Legal Analysis of the PWTHOR Syndicate

**Author:** CreeD CyberSec Legal & Threat Research Desk  
**Jurisdiction:** Republic of India  
**Applicable Statutes:**
- The Information Technology Act, 2000 (as amended 2008)
- The Copyright Act, 1957
- The Bharatiya Nyaya Sanhita, 2023 (BNS)

---

## 1. Information Technology Act, 2000

### Section 43 & Section 66: Unauthorized Access & Hacking
- **Violation:** PWTHOR deploys an unauthorized reverse proxy (`proxy.streamvideo.co.in`) that accesses PenPencil / Physics Wallah servers without authorization, bypassing Cloudflare access controls and siphoning proprietary video stream chunks.
- **Statutory Provision:** Any person who without permission of the owner or person in charge of a computer system secures access to such computer system or damages/disrupts the system commits an offence punishable with imprisonment up to 3 years and fines up to ₹5,00,000.

### Section 66C: Identity Theft & Credential Fraud
- **Violation:** Through `/study/donate-batch`, the syndicate dishonestly induces students to provide their one-time passwords (OTPs) and intercepts their JSON Web Tokens (JWTs).
- **Statutory Provision:** Fraudulently or dishonestly making use of the electronic signature, password, or any other unique identification feature of any other person is punishable with imprisonment up to 3 years and fine up to ₹1,00,000.

### Section 66D: Cheating by Personation Using Computer Resource
- **Violation:** Misrepresenting themselves as an authorized, legitimate portal offering "Free Batches" to lure students into surrendering credentials.
- **Penalty:** Imprisonment up to 3 years and fine.

---

## 2. The Copyright Act, 1957

### Section 51 & Section 63: Copyright Infringement & Distribution
- **Violation:** Educational lectures, proprietary study materials, question banks, and video curricula produced by Physics Wallah faculty are literary and cinematographic works under Section 13.
- **Infringement:** The systematic duplication, relaying, and public distribution of these copyrighted materials without a valid license constitutes willful commercial infringement.
- **Penalty:** Imprisonment for a term which shall not be less than 6 months but which may extend to 3 years, and fine between ₹50,000 and ₹2,00,000.

---

## 3. The Bharatiya Nyaya Sanhita, 2023 (BNS)

### Section 318: Cheating & Dishonest Inducement
- **Violation:** Deceiving students to part with personal authentication data (phone numbers, SMS verification codes) under false pretenses of educational charity ("donate your batch for needy students"), and converting this access for commercial gain via ad arbitrage.
- **Penalty:** Imprisonment up to 3 years, fine, or both.

### Section 61: Criminal Conspiracy
- **Violation:** Collaborative operation between domain registrants in Rajasthan, APK packager operators using Chinese obfuscation tools, and ad-network syndicates (`tipsguru.in`).

---

*This statutory brief serves as foundational documentation for formal complaints to CERT-In, state Cyber Crime Cells, and corporate legal counsels.*
