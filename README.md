# Projet Perso

Projet ayant pour objectif de faire une signalétique de la disponibilité de quelqu'un dans un bureau.

Un peu comme les voyants au-dessus des places de parking de centre commercial.

## IOT: ESP8266

[Ce module](<https://www.amazon.fr/gp/product/B0754W6Z2F/>) a été choisis car il ne coute presque rien et que j'en avais déjà chez moi :)

### IDE

Utilisation de l'IDE Visual Studio Code + extension Arduino car l'IDE de base Arduino ne possède pas d'auto complete... ce qui le rend insupportable.

### Sources

Le code est disponible à cet emplacement:  [```ESP8266\Module```](<https://github.com/kevingrillet/YMG_projet_perso/tree/master/ESP8266/module>).

Pour plus de facilité pour lire le fichier HTML celui-ci est dupliqué ici: [```ESP8266\index.html```](<https://github.com/kevingrillet/YMG_projet_perso/blob/master/ESP8266/index.html>).

Il y a aussi [```ESP8266\ReadMe.md```](<https://github.com/kevingrillet/YMG_projet_perso/tree/master/ESP8266/>) pour aider à la compréhension des différentes interfaces.

### Conseils d'utilisation

Dans un premier temps il faut changer les informations SSID et PSK.

Il est possible d'utiliser un port spécifique (par défaut 80), qu'il faut modifier dans le code source.

En se branchant au moniteur série lors de son premier démarrage (après avoir chargé les données), il est possible de récupérer l'IP du module (via le moniteur série) pour communiquer avec lui.

Pour trouver le module plus facilement, il est possible de s'aider d'un [IP Scanner](<https://www.advanced-ip-scanner.com/>).

## Client

Le client à pour objectif d'envoyer au module les informations de disponibilité.
- <https://www.generacodice.com/en/articolo/427837/How-to-make-an-HTTP-request-in-a-separate-thread-with-timeout>

Il doit ainsi récupérer l'état de l'utilisateur en regardant dans :

- API?
  - Windows
    - <https://stackoverflow.com/questions/45988192/detect-when-user-locks-unlocks-screen-in-windows-7-with-delphi>
  - Teams
    - <https://docs.microsoft.com/en-us/graph/api/resources/presence?view=graph-rest-beta>
    - <https://docs.microsoft.com/en-us/graph/api/presence-get?view=graph-rest-beta&tabs=http>
  - Cisco
    - <https://developer.cisco.com/site/im-and-presence/documents/>
  - Outlook
    - <https://docs.microsoft.com/fr-fr/graph/api/calendar-getschedule?view=graph-rest-1.0&tabs=http>
    - <https://docs.microsoft.com/fr-fr/graph/outlook-get-free-busy-schedule>
- ICalendar
  - Magy > Fichier > Paramètres utilisateur > ICalendar

### Langage

En soit tout fonctionne, Delphi, C#, AutoIt, reste à faire le choix.

J'imagine niveau interface une tray icon + une page de configuration dans laquelle on renseigne les informations essentielles aux API et l'IP:Port du module -> conf.ini

## Question du multi-utilisateur / module ou module sans utilisateur

Pour passer en multi utilisateur / module il serait possible de passer par un tableau et plusieurs paramètres pour signaler la disponibilité.
Ajouter de l'intelligence au module au final, mais est-ce que c'est réellement son but? Il est très limité niveau mémoire et vitesse.

Le plus propre serait d'ajouter une couche serveur avec une BDD qui ferait l'intermédiaire entre le client et le module.

Il serait ainsi possible de configurer que tel client (utilisateur) correspond à tel module.

Il serait aussi possible de faire des routines qui s'occupent de modules sans client (salles de réunion par exemple).
