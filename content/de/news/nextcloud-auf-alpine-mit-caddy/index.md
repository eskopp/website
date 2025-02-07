---
# type: docs 
title: Nextcloud auf Alpine mit Caddy
date: 2025-02-07T06:34:17+01:00
featured: true
draft: false
comment: false
toc: true
reward: true
pinned: false
carousel: true
categories:
  - Image
tags: 
  - Nextcloud
  - Alpine
  - Sever
  - Cloud
  - Cadddy
  - Informatik
authors:
  - ErikSkopp
images: []
---

# Anlegen einer Nextcloud Instanz auf einem Alpine Server mit Caddy
## DNS-Konfiguration für die Subdomain

Um den Server über eine Domain oder Subdomain erreichbar zu machen, ist die Erstellung eines entsprechenden DNS-Records erforderlich. In diesem Fall wird die Domain ``erik-skopp.de`` genutzt und eine Third-Level-Domain mit dem Namen ``nextcloud`` angelegt. Daraus ergibt sich die finale Subdomain: ``nextcloud.erik-skopp.de``.

### Anlegen der Records

Diese Subdomain dient ausschließlich zu Testzwecken. Nach Abschluss dieses Berichts werden sowohl der Webserver als auch die Nextcloud-Installation sowie die zugehörigen DNS-Einträge entfernt.

Zur Vereinfachung werden hier nur zwei Domains verwendet:

- Der **A-Record** weist die Domain der IPv4-Adresse `152.53.120.57` zu.
- Der **AAAA-Record** löst `nextcloud.erik-skopp.de` auf IPv6 auf, nämlich auf `2a0a:4cc0:c0:4540::1`.

Für dieses Projekt nutze ich einen **Netcup-Server**, der einen **/64-Adresspool** bereitstellt. Konkret sind dies:

- **Link-Local-Adresse:** `fe80::a8cb:d0ff:fe50:ab47/10` (nicht von außen erreichbar)
- **Global Unicast-Subnetz:** `2a0a:4cc0:c0:4540::/64` (öffentlich routbar)

Da die **Link-Local-Adresse (`fe80::.../10`) nicht extern erreichbar** ist, bleibt nur die **routbare Global Unicast-Adresse**. 
Aus dem `/64`-Adresspool habe ich die `:1` als Host-Adresse gewählt – dies geschah aus rein praktischen Gründen und hat keinen Einfluss auf den weiteren Ablauf.


![DNS Eintrag](dns_eintraege.webp)


### Testen der Records

### DNS-Checker
Die Überprüfung der DNS-Einträge erfolgt auf zwei Wegen. Eine Möglichkeit bietet die externe Website [DNSChecker](https://dnschecker.org/#A/nextcloud.erik-skopp.de). Dort kann die gewünschte URL eingegeben und der zu überprüfende DNS-Record ausgewählt werden. Die Ergebnisse werden übersichtlich dargestellt und zeigen, in welchen Regionen der Eintrag bereits propagiert wurde und wo er noch aussteht.

![DNS Checker](dnschecker.webp)

#### DIG 
> dig (Domain Information Groper) ist ein leistungsstarkes Kommandozeilen-Tool zum Abfragen von DNS-Informationen. Es wird häufig von Netzwerkadministratoren und Entwicklern [...] genutzt, um DNS-Records von Domains zu analysieren. (Quelle: verschiedene)

Wir nutzen dig um mit einem CLI Tool zu prüfen ob die DNS Einträge für die Nextcloud Domain vorhanden sind. Auf Gründen der einfachheit werde ich hier nur auf den `IPv4` bzw `A-Record` eingehen, da nur dieser hier relevant ist. Für den anderen Record bedarf es keine Änderung. Auf dem Server werden beide in der Caddy Config abgefangen. 


```bash
> dig nextcloud.erik-skopp.de

; <<>> DiG 9.18.30-0xxx <<>> nextcloud.erik-skopp.de
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8998
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;nextcloud.erik-skopp.de.       IN      A

;; ANSWER SECTION:
nextcloud.erik-skopp.de. 182    IN      A       152.53.120.57

;; Query time: 49 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)
;; WHEN: Fri Feb 07 10:17:31 CET 2025
;; MSG SIZE  rcvd: 68
```
In der Antwortsektion ist zu erkennen, dass der Server den A-Record erfolgreich aufgelöst hat. Daher können wir uns nun der Serverkonfiguration widmen.


## Einrichten des Servers
### Grundlagen von Alpine
In diesem Projekt verwenden wir Alpine Linux in der Version `3.21.3`, die über die offizielle [Alpine-Downloadseite](https://alpinelinux.org/downloads/) verfügbar ist. Wir gehen davon aus, dass eine installierte und funktionsfähige Alpine-Version bereits vorhanden ist.
