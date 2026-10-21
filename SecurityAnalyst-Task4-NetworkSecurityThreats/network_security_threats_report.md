# Research Report: Common Network Security Threats

## 1. Introduction

Network security has become increasingly important as organizations rely on interconnected systems, cloud services, and digital infrastructure, expanding the attack surface available to cybercriminals and other threat actors. According to the ENISA Threat Landscape 2025 report, Distributed Denial-of-Service (DDoS) attacks accounted for 76.7% of recorded cybersecurity incidents, while the ENISA Threat Landscape 2026 report identified DDoS attacks in 51.3% of recorded incidents, demonstrating their continued prominence despite differences in reporting periods and methodology [1], [2]. At the same time, artificial intelligence is increasingly being used to enhance malicious activities, while faster vulnerability exploitation places additional pressure on network defenders [1]–[3]. These developments highlight the importance of proactive threat identification, continuous network monitoring, and effective mitigation strategies to protect service availability, sensitive information, and business continuity. This report examines four common network security threats—DoS/DDoS attacks, Man-in-the-Middle (MITM) attacks, IP spoofing, and DNS poisoning—focusing on how they operate, their real-world impact, and practical methods for preventing or mitigating them.

## 2. Denial-of-Service (DoS) and Distributed Denial-of-Service (DDoS) Attacks

### Description and How They Work

A Denial-of-Service (DoS) attack aims to disrupt the availability of a network service, website, or server by overwhelming its resources or exploiting weaknesses that prevent it from responding to legitimate users. A DoS attack typically originates from a single source, whereas a Distributed Denial-of-Service (DDoS) attack involves multiple sources acting simultaneously, often through a botnet of compromised devices. These attacks can exhaust network bandwidth, processing capacity, or available connections, causing slow response times, request timeouts, or complete service outages. Their primary target is **availability**, one of the three principles of the CIA triad. As highlighted by ENISA's threat landscape reports, DDoS attacks remain a significant concern for organizations operating internet-facing services [1], [2].

### Real-World Example: Dyn DNS Attack (2016)

On October 21, 2016, Dyn, a managed DNS provider, experienced a large-scale DDoS attack involving the Mirai botnet. Attackers generated high volumes of TCP and UDP traffic targeting Dyn's DNS infrastructure, disrupting DNS resolution for numerous online services. As a result, users experienced difficulties accessing websites and platforms that depended on Dyn's services. The incident demonstrated how an attack against shared network infrastructure can affect multiple organizations simultaneously [4].

### Potential Impact

Successful DoS and DDoS attacks can cause significant service disruptions and prevent legitimate users from accessing essential online resources. For businesses, prolonged downtime may lead to lost revenue, interrupted operations, and reputational damage. For example, customers of an e-commerce platform may be unable to place new orders, track existing purchases, or request cancellations. Such incidents can also increase operational costs as organizations work to restore services and maintain business continuity.

### Mitigation Strategies

1. **Rate Limiting:** Configure network or application-level controls to restrict excessive requests within a defined time period. Thresholds should be adjusted carefully to avoid blocking legitimate users who share the same public IP address.
2. **Traffic Monitoring and Behavioral Analysis:** Continuously monitor network traffic for unusual request volumes, repetitive access patterns, and other indicators of automated malicious activity. Combining multiple indicators helps distinguish suspicious traffic from legitimate user activity.
3. **Upstream DDoS Protection:** Use specialized DDoS mitigation services, traffic scrubbing, or appropriately configured content delivery networks (CDNs) to filter or absorb malicious traffic before it saturates the organization's internet connection. This is particularly important for large volumetric attacks that cannot be stopped effectively by a firewall located behind an already congested network link.

## 3. Man-in-the-Middle (MITM) Attacks

### Description and How They Work

A Man-in-the-Middle (MITM) attack occurs when an attacker secretly positions themselves between two communicating parties to intercept, monitor, or modify exchanged information. Attackers may exploit techniques such as ARP spoofing, malicious Wi-Fi hotspots, or compromised digital certificates to interfere with network communications. For example, ARP spoofing can trick devices on a local network into sending traffic through an attacker-controlled system. MITM attacks primarily threaten the **confidentiality and integrity** of information by enabling unauthorized access to sensitive data or manipulation of transmitted content [5], [6], [11].

### Real-World Example: DigiNotar Certificate Authority Breach (2011)

In 2011, attackers compromised DigiNotar, a Dutch certificate authority, and issued fraudulent digital certificates for major websites, including \*.google.com. A fraudulent Google certificate was used in MITM attacks targeting internet users in Iran. Because DigiNotar was trusted by browsers at the time, attackers who could intercept network traffic could impersonate legitimate websites without necessarily triggering certificate warnings. The incident demonstrated how a compromised certificate authority can undermine HTTPS authentication and expose supposedly secure communications [9], [10].

### Potential Impact

MITM attacks may expose usernames, passwords, session information, and other confidential data. Attackers can also alter transmitted information, inject malicious content, or impersonate trusted services. For organizations, successful attacks may result in unauthorized account access, data breaches, financial losses, operational disruption, and reputational damage [6], [11].

### Mitigation Strategies

1. **Enforce Secure TLS/HTTPS:** Use TLS 1.3, or properly configured TLS 1.2 where necessary, and ensure that applications validate server certificates correctly. Keep trusted certificate stores updated and never ignore certificate validation errors [7].
2. **Secure Network Infrastructure:** Protect wireless networks using WPA3 where supported, update router and access-point firmware, and configure managed switches with protections such as Dynamic ARP Inspection to reduce ARP spoofing risks [11].
3. **Implement Phishing-Resistant Multi-Factor Authentication:** Deploy FIDO2/WebAuthn-based authentication, including compatible security keys or passkeys, to reduce the risk of account compromise through adversary-in-the-middle phishing attacks. Unlike traditional one-time codes, these authentication methods are designed to resist authentication attempts through fraudulent websites [8].

## 4. IP Spoofing

### Description and How It Works

IP spoofing is a technique in which an attacker modifies the source IP address in a network packet to make it appear as though the packet originated from another device. Because IP addresses are not inherently authenticated, forged packets may be used to conceal the attacker's origin, impersonate another system, or redirect responses toward an unsuspecting victim. IP spoofing is commonly associated with reflection and amplification DDoS attacks, particularly those involving UDP-based services [12], [13].

### Real-World Example: GitHub DDoS Attack (2018)

On February 28, 2018, GitHub experienced a large-scale DDoS attack that peaked at approximately 1.35 Tbps. Attackers exploited publicly accessible memcached servers by sending requests containing GitHub's spoofed source IP addresses. The servers consequently directed amplified responses toward GitHub, overwhelming its network infrastructure. The incident demonstrated how IP spoofing can enable powerful reflection and amplification attacks without requiring attackers to directly generate the full volume of traffic received by the victim [14], [15].

### Potential Impact

IP spoofing can facilitate service outages, network congestion, and resource exhaustion when used in DDoS attacks. It may also complicate incident investigation by concealing the true origin of malicious packets or making innocent systems appear responsible. In environments that rely on IP-based trust rules, forged addresses may contribute to unauthorized access attempts, although IP spoofing alone does not automatically bypass modern authentication mechanisms [12], [13].

### Mitigation Strategies

1. **Ingress and Egress Filtering:** Apply source-address filtering at network boundaries to reject packets with invalid or unexpected source IP addresses. Internet service providers and organizations should follow BCP 38 guidance to reduce the transmission of spoofed traffic [12].
2. **Source Address Validation:** Configure routers with suitable source-validation mechanisms, such as Unicast Reverse Path Forwarding (uRPF), where network topology permits. Account for asymmetric routing to avoid accidentally dropping legitimate traffic [13].
3. **Restrict UDP Amplification Services:** Disable unnecessary publicly accessible UDP services, secure exposed services such as memcached, and apply appropriate rate limits to reduce opportunities for reflection and amplification attacks [15].

## 5. DNS Poisoning / DNS Spoofing

### Description and How It Works

DNS poisoning is a network attack in which false DNS information causes a legitimate domain name to resolve to an incorrect IP address. In DNS cache poisoning, malicious records are stored in a DNS resolver's cache and may affect multiple users. Attackers can exploit forged DNS responses or compromised DNS infrastructure to redirect users to fraudulent websites, even when they enter the correct domain name. These attacks primarily threaten the **confidentiality and integrity** of network communications [16], [20].

### Real-World Example: MyEtherWallet DNS Hijacking (2018)

On April 24, 2018, attackers manipulated Border Gateway Protocol (BGP) routing to redirect traffic intended for Amazon Route 53 DNS servers. This enabled attacker-controlled systems to provide fraudulent DNS responses for myetherwallet.com, directing affected users to a phishing website instead of the legitimate cryptocurrency wallet service. Users who ignored browser certificate warnings and entered sensitive information risked having their cryptocurrency stolen. The incident demonstrated how DNS manipulation, enabled by a routing attack, can compromise users without modifying the legitimate website itself [17], [18].
Although the attack involved BGP route hijacking rather than traditional DNS cache poisoning, it demonstrates how fraudulent DNS responses can redirect users to attacker-controlled destinations [17], [18].

### Potential Impact

DNS poisoning can redirect users to phishing websites designed to steal credentials, personal information, or financial assets. Malicious destinations may also distribute malware or prevent access to legitimate services. When a shared DNS resolver is affected, multiple users and organizations may receive incorrect DNS responses, potentially causing financial losses, operational disruption, and reputational damage [20].

### Mitigation Strategies

1. **Enable DNSSEC Validation:** Configure DNS resolvers to validate DNSSEC signatures for signed domains. This helps detect forged or modified DNS responses and prevents invalid records from being accepted [16].
2. **Secure and Update DNS Resolvers:** Keep DNS software patched and use unpredictable transaction IDs and randomized UDP source ports to make traditional DNS response-spoofing attacks more difficult [19].
3. **Protect and Monitor DNS Infrastructure:** Restrict administrative access, use strong authentication for DNS management accounts, and monitor DNS records and routing announcements for unexpected changes. Investigate suspicious redirections and certificate warnings promptly [17], [18].

## 6. Comparison of Network Security Threats

| Threat        | Attack Vector                               | Who Is at Risk?                        | Execution Difficulty  | Mitigation Ease       |
|---------------|---------------------------------------------|----------------------------------------|-----------------------|-----------------------|
| DoS/DDoS      | Traffic flooding and resource exhaustion    | Websites, servers, online services     | Moderate              | Moderate to Difficult |
| MITM          | Communication interception and manipulation | Network users, organizations           | Moderate to Difficult | Moderate              |
| IP Spoofing   | Forged source IP addresses                  | Internet-facing systems, networks      | Moderate              | Moderate              |
| DNS Poisoning | Fraudulent DNS responses and redirection    | Internet users, DNS-dependent services | Moderate to Difficult | Moderate              |


## 7. Conclusion

DoS/DDoS attacks, Man-in-the-Middle attacks, IP spoofing, and DNS poisoning exploit different weaknesses in network availability, communication security, packet addressing, and name resolution. Although their techniques vary, all four can disrupt business operations, expose sensitive information, or undermine trust in network services. The incidents involving Dyn, DigiNotar, GitHub, and MyEtherWallet demonstrate that these threats have practical consequences for organizations and users.

Three key takeaways for network administrators are:

1. **Apply layered security controls:** Combine DDoS protection, secure TLS configurations, source-address filtering, and DNSSEC validation rather than relying on a single defensive measure.
2. **Maintain visibility and respond quickly:** Monitor network traffic, DNS activity, and authentication events to identify anomalies and investigate potential attacks before their impact increases.
3. **Keep infrastructure secure and updated:** Regularly patch network devices and DNS resolvers, review access controls, and test incident response procedures to strengthen operational resilience.

Ultimately, effective network security depends on proactive prevention, continuous monitoring, and a well-prepared response to emerging threats.

## References

[1] European Union Agency for Cybersecurity (ENISA). (2025). ENISA Threat Landscape 2025. October 2025. Sections 1, 3, and 4.5, pp. 6, 8, 14–15.

[2] European Union Agency for Cybersecurity (ENISA). (2026). ENISA Threat Landscape 2026. September 2026. Executive Summary, Methodology, and AI-related threat trends, pp. 7–9, 15.

[3] Fortinet. (2026). 2026 Global Threat Landscape Report. <https://www.fortinet.com/resources/reports/threat-landscape-report>

[4] Hilton, S. (2016, October 26). Dyn Analysis Summary of Friday, October 21 Attack. Dyn. <https://postmortem.io/incidents/dyn--2016-10-21--managed-dns-ddos-mirai-attack/>

[5] National Institute of Standards and Technology (NIST). (2016). Man-in-the-Middle Attack (MitM). NIST Computer Security Resource Center Glossary. <https://csrc.nist.gov/glossary/term/man_in_the_middle_attack>

[6] United States Computer Emergency Readiness Team (US-CERT). (2015). Securing End-to-End Communications (Alert TA15-120A). Cybersecurity and Infrastructure Security Agency (CISA). <https://www.cisa.gov/news-events/alerts/2015/04/30/securing-end-end-communications>

[7] McKay, K., & Cooper, D. (2019). Guidelines for the Selection, Configuration, and Use of Transport Layer Security (TLS) Implementations (NIST Special Publication 800-52, Revision 2). National Institute of Standards and Technology. <https://doi.org/10.6028/NIST.SP.800-52r2>

[8] Cybersecurity and Infrastructure Security Agency (CISA). (2022). Implementing Phishing-Resistant MFA. <https://www.cisa.gov/sites/default/files/2023-01/fact-sheet-implementing-phishing-resistant-mfa-508c.pdf>

[9] European Union Agency for Cybersecurity (ENISA). (2011). Operation Black Tulip: Certificate Authorities Lose Authority. <https://www.enisa.europa.eu/sites/default/files/all_files/Operation_Black_Tulip_v2.pdf>

[10] Adkins, H. (2011, August 29). An Update on Attempted Man-in-the-Middle Attacks. Google Security Blog. <https://security.googleblog.com/2011/08/update-on-attempted-man-in-middle.html>

[11] Fortinet. (n.d.). What Is a Man-in-the-Middle (MITM) Attack? Types & Examples. Fortinet Cybersecurity Glossary. <https://www.fortinet.com/resources/cyberglossary/man-in-the-middle-attack>

[12] Ferguson, P., & Senie, D. (2000). Network Ingress Filtering: Defeating Denial of Service Attacks which employ IP Source Address Spoofing (RFC 2827, BCP 38). RFC Editor. <https://www.rfc-editor.org/rfc/rfc2827>

[13] Baker, F., & Savola, P. (2004). Ingress Filtering for Multihomed Networks (RFC 3704, BCP 84). RFC Editor. <https://www.rfc-editor.org/rfc/rfc3704>

[14] GitHub. (2018, March 1). February 28th DDoS Incident Report. <https://github.blog/news-insights/company-news/ddos-incident-report/>

[15] Cybersecurity and Infrastructure Security Agency (CISA). (2014). UDP-Based Amplification Attacks (Alert TA14-017A). <https://www.cisa.gov/ncas/alerts/ta14-017a>

[16] Arends, R., Austein, R., Larson, M., Massey, D., & Rose, S. (2005). Protocol Modifications for the DNS Security Extensions (RFC 4035). RFC Editor. <https://www.rfc-editor.org/rfc/rfc4035>

[17] Poinsignon, L. (2018, April 24). BGP Leaks and Cryptocurrencies. Cloudflare Blog. <https://blog.cloudflare.com/bgp-leaks-and-crypto-currencies/>

[18] Siddiqui, A. (2018, April 27). What Happened? The Amazon Route 53 BGP Hijack to Take Over Ethereum Cryptocurrency Wallets. Internet Society. <https://www.internetsociety.org/blog/2018/04/amazons-route-53-bgp-hijack/>

[19] Hubert, A., & van Mook, R. (2009). Measures for Making DNS More Resilient against Forged Answers (RFC 5452). RFC Editor. <https://www.rfc-editor.org/rfc/rfc5452>

[20] Fortinet. (n.d.). What Is DNS Poisoning and DNS Spoofing? Fortinet Cybersecurity Glossary. <https://www.fortinet.com/resources/cyberglossary/dns-poisoning>
