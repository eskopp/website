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
Um den Server über eine Domain oder Subdomain erreichbar zu machen, ist die Erstellung eines entsprechenden DNS-Records erforderlich. In diesem Fall wird die Domain ``erik-skopp.de`` genutzt und eine Third-Level-Domain mit dem Namen ``nextcloud`` angelegt. Daraus ergibt sich die finale Subdomain: ``nextcloud.erik-skopp.de``.

Diese Subdomain dient ausschließlich zu Testzwecken. Nach Abschluss dieses Berichts werden sowohl der Webserver als auch die Nextcloud-Installation sowie die zugehörigen DNS-Einträge entfernt.


## Setzen der DNS Einträge
![DNS Eintrag](dns_eintraege.webp)


