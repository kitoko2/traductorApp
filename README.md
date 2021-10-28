# traductorApp

application mobile pour la traduction par : \
► la voix \
► saisie au clavier \
► possibilité de traduire le texte sur une photo prise ou une capture d'ecran avec l'intelligence artificiel  \
(pratique pour nos voyageurs qui peuvent traduire par exemple le texte sur les panneaux ) 

# langues disponibles

Nous avons implémenté pour l'instant 08 langues (parmis les 10 langues les plus parlé au monde)  \
► l'anglais  \
► le francais  \
► l'arabe  \
► le chinois  \
► le russe  \
► l'allemand  \
► l'italien \
► l'espagnol 

# autres

Nous avons aussi ajouté une base de donnée locale pour stocker les traductions effectuées.

# partie technique

► pour la voix :  \
  speech_to_text -> pour convertir la voix en text et ensuite traduire |
  flutter_tts -> pour convertir le text en voix après la traduction \
► pour la traduction :  \
  translator -> pour traduire de la langue de départ à la langue d'arrivé \
► pour les notifications :  \
  firebase_messaging -> pour gérer les notifications en background \
► pour l'intelligence artificielle : \
  google_ml_kit -> pour la reconnaissance de text sur l'image 
