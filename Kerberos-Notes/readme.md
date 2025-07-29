J'ai pour projet de créer un environnement Active Directory avec authentification Kerberos.

Pourquoi ? 

Je veux exploiter les failles possibles existantes de Kerberos pour mieux les comprendres et les sécuriser.

- Un serveur AD --> DNS / Kerberos
- Clients Windows 2/3

Failles :

- AS-REP Roasting

- Kerberoasting

- Pass-the-Ticket

- Over-Pass-the-Hash

- DCSync

- Abuse de msDS-AllowedToActOnBehalfOfOtherIdentity
