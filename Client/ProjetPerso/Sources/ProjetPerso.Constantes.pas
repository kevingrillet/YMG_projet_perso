unit ProjetPerso.Constantes;

interface

const
   // Adresse des fichiers
   CST_CONF_FILE = 'ProjetPersoConf.ini';
   CST_LOG_FILE = 'ProjetPersoConf.log';

   // Gestion des erreurs
   CST_ERROR = 'ERROR';
   CST_ERROR_VALIDATION = 'Probl�me lors de la communication avec le module';

   // Les diff�rents GPIO pour modifier l'�tat d'une LED
   CST_GPIO_OFF = '0';
   CST_GPIO_GREEN = '5';
   CST_GPIO_YELLOW = '14';
   CST_GPIO_RED = '4';

   // Le r�sultat de l'�tat de la LED
   CST_RESULT_OFF = 'OFF';
   CST_RESULT_GREEN = 'GREEN';
   CST_RESULT_YELLOW = 'YELLOW';
   CST_RESULT_RED = 'RED';

   // Les diff�rentes adresses � contacter sur le module
   CST_URL_READ_REVICE = 'readDeviceName';
   CST_URL_READ_LED = 'readLED';
   CST_URL_SET_GPIO = 'setGPIO?gpio=';

   { const }
implementation

end.
