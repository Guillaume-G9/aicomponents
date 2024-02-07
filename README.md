# ARISTOTE 

## NEXT STEPS:

### Creuser le formattage JSON : 

Paramètre 'response_format' : Parser le JSON en réponse pour avoir plus de contrôle sur la structure du composant. 

### Déclencher l'Account Summary avec un bouton : 

Pour éviter une consommation de tokens trop importante, ne pas laisser le summary se lancer à chaque refresh de page.

### AI Account Assistant : 

Envoyer le payload de l'account summary à l'assistant : 
- Passer le payload au prompt sortant pour ne pas avoir à requêter l'account une deuxième fois si le summary à déjà été triggered.

