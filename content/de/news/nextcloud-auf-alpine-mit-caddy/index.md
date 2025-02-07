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


## DNS - Einträge
Um den Server über eine Domain oder Subdomain erreichbar zu machen, ist die Erstellung eines entsprechenden DNS-Records erforderlich. In diesem Fall wird die Domain ``erik-skopp.de`` genutzt und eine Third-Level-Domain mit dem Namen ``nextcloud`` angelegt. Daraus ergibt sich die finale Subdomain: ``nextcloud.erik-skopp.de``.

Diese Subdomain dient ausschließlich zu Testzwecken. Nach Abschluss dieses Berichts werden sowohl der Webserver als auch die Nextcloud-Installation sowie die zugehörigen DNS-Einträge entfernt.


### Setzen der DNS Einträge
## DNS-Konfiguration für die Subdomain

Zur Vereinfachung werden hier nur zwei Domains verwendet:

- Der **A-Record** weist die Domain der IPv4-Adresse `152.53.120.57` zu.
- Der **AAAA-Record** löst `nextcloud.erik-skopp.de` auf IPv6 auf, nämlich auf `2a0a:4cc0:c0:4540::1`.

Für dieses Projekt nutze ich einen **Netcup-Server**, der einen **/64-Adresspool** bereitstellt. Konkret sind dies:

- **Link-Local-Adresse:** `fe80::a8cb:d0ff:fe50:ab47/10` (nicht von außen erreichbar)
- **Global Unicast-Subnetz:** `2a0a:4cc0:c0:4540::/64` (öffentlich routbar)

Da die **Link-Local-Adresse (`fe80::.../10`) nicht extern erreichbar** ist, bleibt nur die **routbare Global Unicast-Adresse**. 
Aus dem `/64`-Adresspool habe ich die `:1` als Host-Adresse gewählt – dies geschah aus rein praktischen Gründen und hat keinen Einfluss auf den weiteren Ablauf.

![DNS Eintrag](dns_eintraege.webp)


