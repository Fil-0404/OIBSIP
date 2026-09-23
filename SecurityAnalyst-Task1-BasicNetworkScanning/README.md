# Basic Network Scanning with Nmap

## Objective

The objective of this task is to perform basic network scanning using Nmap in a controlled virtual lab environment. The scan is used to identify open ports, running services, service versions, and available operating system information on a target machine.

The results are then analyzed to understand the potential security risks associated with the exposed network services.

---

## Lab Environment

The task was performed in a controlled virtual lab environment using KVM/QEMU and libvirt on a Fedora Linux host.

- Host system: Fedora Linux
- Scanner: Kali Linux virtual machine
- Target: Ubuntu Server 26.04.1 LTS virtual machine
- Virtualization: KVM/QEMU with libvirt
- Network:libvirt default NAT network (`192.168.122.0/24`)
- Kali scanner IP: `192.168.122.166`
- Ubuntu target IP: `192.168.122.137`

Both virtual machines were connected to the same private libvirt NAT network. The Ubuntu Server was intentionally configured with SSH and Apache HTTP services for scanning and analysis.

---

## What is Nmap?

Nmap (Network Mapper) is an open-source network scanning and discovery tool. It can be used to identify active hosts, open ports, running network services, service versions, and information about a target operating system.

In this task, Nmap was used from the Kali Linux virtual machine to examine the Ubuntu Server target. Different scan options were used to progressively gather more information about the target:

- A basic scan was used to identify open TCP ports and their associated services.
- Service version detection (`-sV`) was used to identify the software and versions running on the open ports.
- OS detection (`-O`) was used to analyze the target's TCP/IP behavior and attempt to identify its operating system.

---

## Why Network Scanning Matters

Network scanning is an important part of security assessment because it helps identify which systems and network services are exposed and reachable.

Open ports increase the attack surface of a system because each exposed service represents a possible point of interaction with the network. By identifying open ports and the services running on them, a security analyst can determine whether those services are necessary, properly configured, and appropriately protected.

Service and version detection can also provide useful information for further security assessment. However, discovering an open port or a specific software version does not automatically mean that a vulnerability exists. Additional analysis is required before a service can be considered vulnerable.

In this lab, network scanning revealed that the Ubuntu target exposed SSH on TCP port 22 and HTTP on TCP port 80. These findings were analyzed to understand their potential security implications.

---

## Nmap Installation

Nmap was installed and verified on the Kali Linux scanner using the APT package manager:

```bash
sudo apt install nmap
```

The package manager confirmed that Nmap was already installed and up to date:

```text
nmap is already the newest version (7.99+dfsg-1kali1).
nmap set to manually installed.
```

The Nmap version used for the scans was:

```text
Nmap 7.99
```

The installed version can also be verified using:

```bash
nmap --version
```

---

## Network Connectivity

Before performing the scans, connectivity between the Kali scanner and the Ubuntu target was verified using ICMP echo requests:

```bash
ping -c 4 192.168.122.137
```

The target responded successfully with:

```text
4 packets transmitted, 4 received, 0% packet loss
```

This confirmed that the Ubuntu target was reachable from the Kali Linux scanner over the virtual network.

A successful ping only confirms network reachability. It does not identify which TCP ports or services are available, which is why Nmap was used for further analysis.

---

## Scan 1: Basic Nmap Scan

The first scan was performed using:

```bash
nmap 192.168.122.137
```

The scan identified two open TCP ports:

```text
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http
```

Nmap reported that 998 of the commonly scanned TCP ports were closed.

The results show that the target was reachable and exposed two network services: SSH and HTTP.

---

## Scan 2: Service and Version Detection

Service and version detection was performed using:

```bash
nmap -sV 192.168.122.137
```

The scan returned:

```text
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.2p1 Ubuntu 2ubuntu3.6 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.66 ((Ubuntu))
```

This provided additional information about the software running behind the two open ports.

The SSH service was identified as OpenSSH 10.2p1 with the Ubuntu package version `2ubuntu3.6`, while the HTTP service was identified as Apache HTTP Server 2.4.66.

Nmap also reported:

```text
Service Info: OS: Linux
```

This information was inferred during service detection and should not be confused with the separate operating system fingerprinting performed using the `-O` option.

---

## Scan 3: OS Detection

Operating system detection was performed using:

```bash
nmap -O 192.168.122.137
```

Nmap successfully performed TCP/IP fingerprinting but did not find an exact operating system match:

```text
No exact OS matches for host
```

The scan also reported:

```text
Network Distance: 1 hop
OS detection performed.
```

The lack of an exact OS match is not a scan failure. Nmap OS detection is based on analyzing characteristics of the target's network responses and comparing the resulting fingerprint with known fingerprints.

In this controlled lab, the target operating system is known to be Ubuntu Server 26.04.1 LTS because the virtual machine was created specifically for this task. However, the Nmap `-O` scan itself did not identify an exact operating system match. This distinction is preserved in the findings rather than claiming an OS result that Nmap did not produce.

---

## Findings and Security Analysis

The scans identified two remotely accessible TCP services on the Ubuntu target.

### TCP Port 22 - SSH

Service: OpenSSH 
Detected version: OpenSSH 10.2p1 Ubuntu 2ubuntu3.6 
Purpose: Secure remote administration and command-line access.

SSH provides encrypted remote access to a system and is commonly used for server administration. An open SSH port is not itself a vulnerability, but it increases the system's externally reachable attack surface.

Potential security concerns include:

- Weak or reused passwords may expose accounts to credential-based attacks.
- Unnecessary SSH exposure may allow unauthorized users to attempt authentication.
- Outdated or improperly configured SSH software may introduce security risks.
- Excessive authentication attempts may require additional monitoring or protection.

Possible defensive measures include keeping OpenSSH updated, using strong authentication, preferring SSH keys where appropriate, restricting network access to trusted sources, and disabling unnecessary remote access.

### TCP Port 80 - HTTP

Service: Apache HTTP Server 
Detected version: Apache httpd 2.4.66 
Purpose: Serving web content using HTTP.

Port 80 provides standard HTTP communication. HTTP does not provide transport encryption, so sensitive information transmitted using plain HTTP could potentially be observed or modified when communicating over an untrusted network.

An exposed web server also increases the attack surface because vulnerabilities may exist in the web server configuration, enabled modules, or the web applications hosted by the server.

Possible defensive measures include keeping Apache and hosted applications updated, disabling unnecessary modules and services, applying appropriate access controls, and using HTTPS/TLS for sensitive or production web traffic.

### Overall Assessment

The Nmap scans confirmed that the target exposes SSH and HTTP services. These open ports represent legitimate network services intentionally configured for this lab.

No vulnerability was proven solely by these scans. Nmap identified the exposed services and their versions, providing information that could be used as the starting point for further vulnerability assessment.

---

## Scan Results

The complete raw Nmap output from the three scans is stored in:

```text
nmap_scan_results.txt
```

This file contains the output from:

```bash
nmap 192.168.122.137
nmap -sV 192.168.122.137
nmap -O 192.168.122.137
```

---

## Screenshots

Terminal screenshots documenting the scans are stored in the `screenshots/` directory.

The screenshots include:

- Basic Nmap scan
- Service and version detection
- OS detection

---

## Ethical Use

Network scanning must only be performed against systems that the tester owns or has explicit authorization to assess.

Scanning systems without permission may violate organizational policies, terms of service, or applicable laws. Security tools such as Nmap should therefore be used responsibly and only within an authorized scope.

For this task, all scanning was performed in a controlled lab environment consisting of personally created virtual machines connected through a private libvirt NAT network. The Ubuntu Server target was intentionally created and configured for security testing.

No external or unauthorized systems were scanned.

---

## Conclusion

This task demonstrated how Nmap can be used to perform basic network reconnaissance and security assessment in a controlled environment.

The basic scan identified two open TCP ports, while service version detection identified OpenSSH and Apache HTTP Server running on those ports. OS detection successfully collected a TCP/IP fingerprint, although Nmap was unable to determine an exact operating system match.

The exercise also demonstrated an important security principle: an open port or detected software version does not automatically indicate a vulnerability. Network scanning provides visibility into exposed services and attack surface, which can then be used to guide further security analysis.

All testing was conducted within an authorized virtual lab environment.
