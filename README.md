# Projet Perso

Projet ayant pour objectif de faire une signalétique de la disponibilité de quelqu'un dans un bureau.

Un peu comme les voyants au-dessus des places de parking de centre commercial.

Cette idée nous vient d'un cas réel: les CDP ayant été nos voisins pendant presque un an nous avons répondu toutes les 10 minutes à la question "Est ce qu'ils sont disponibles?" car leur porte était fermée.

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

### Évolutions possibles pour un module multi-utilisateur

- Ajouter une gestion multilisateur via une [```map```] où les statuts sont affichés suivant la règle suivante:
[```Occupé [RED] > Absent [YELLOW] > Disponible [GREEN] > Invisible [OFF]```]

- Ajouter un système pour vider la map toutes les heures pour ne pas conserver un utilisateur n'ayant pas été déconnecté proprement.
	- <https://circuits4you.com/2018/01/02/esp8266-nodemcu-ntp-time-clock/>

## Client

Le client à pour objectif d'envoyer au module les informations de disponibilité.

Il doit ainsi récupérer l'état de l'utilisateur en regardant dans :

- Windows
    - <https://stackoverflow.com/questions/45988192/detect-when-user-locks-unlocks-screen-in-windows-7-with-delphi>
- Teams
    - Authentification:
        - <https://docs.microsoft.com/fr-fr/graph/auth-register-app-v2?context=graph%2Fapi%2Fbeta&view=graph-rest-beta>
        - <https://www.example-code.com/delphidll/microsoft_graph_oauth2_access_token.asp>
    - Présence:
        - <https://docs.microsoft.com/fr-fr/graph/api/presence-get?view=graph-rest-beta&tabs=http> 

Pour Teams ce n'est actuellement pas possible, nous avons un problème avec l'inscription de notre application sur la Plateforme d’identités Microsoft. Nous n'avons pas les droits.



### Langage

Le client a été réalisé en Delphi.

Il se compose d'un écran de paramétrage et d'une TrayIcon, et enregistre son paramétrage (IP et automatismes) dans un fichier [```.ini```] caché.

![](https://raw.githubusercontent.com/kevingrillet/YMG_projet_perso/master/Client/R&D/ProjetPerso-Client.png)
