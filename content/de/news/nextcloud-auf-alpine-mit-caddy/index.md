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
Für die Subdomain werden hier aus Gründen der einfachheit nur 2 Domains. Der ``A-Record`` löst die Domain auf die IPv4 Adresse ``152.53.120.57`` auf.
Der ```AAA-Record``` hingegen löst ``nextcloud.erik-skopp.de`` auf IPv6 auf und damit auf ``2a0a:4cc0:c0:4540::1``. Für dieses Projekt nutze Ich einen Netcup Server. Diese bieten einen ``/64`` Adresspool an. In dem Fall ist es ``e80::a8cb:d0ff:fe50:ab47/10`` und ``2a0a:4cc0:c0:4540::/64``. Die ``fe80::.../10`` ist eine Link Local Adresse und ist von außen nicht erreichbar. Daher bleibt nur die rootbare Global Unicast Adresse. Aus dem ``/64`` Pool habe ich die ``:1`` als Host Adresse gewählt. Das ist rein aus praktischen Gründen geschehen und hat kein Einfluss auf den weiteren Ablauf.
![DNS Eintrag](dns_eintraege.webp)


