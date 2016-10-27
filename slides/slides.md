    
    np6         okiwi                   gfi                {epitech}
                          _ _        _                   
               __ _  __ _(_) | ___  | |_ ___  _   _ _ __ 
    Infotel   / _` |/ _` | | |/ _ \ | __/ _ \| | | | '__|
             | (_| | (_| | | |  __/ | || (_) | |_| | |          upwiser
              \__,_|\__, |_|_|\___|  \__\___/ \__,_|_|   
                    |___/                                
            ____                _                         ____   ___  _  __   
           | __ )  ___  _ __ __| | ___  __ _ _   ___  __ |___ \ / _ \/ |/ /_  
           |  _ \ / _ \| '__/ _` |/ _ \/ _` | | | \ \/ /   __) | | | | | '_ \ 
    jet    | |_) | (_) | | | (_| |  __/ (_| | |_| |>  <   / __/| |_| | | (_) |
    brains |____/ \___/|_|  \__,_|\___|\__,_|\__,_/_/\_\ |_____|\___/|_|\___/ 
                                                                                
                    coolworking              neotech
                                             solutions              lectra
    onepoint.
    
    #atbdx

---

![](ansible.svg)

---

#_

# Développement guidé par les tests de rôles Ansible

Nous utilisons Ansible pour :

* automatiser l'installation de nos serveurs
* automatiser la maintenance de nos serveurs
* 30 roles ansible / 200 serveurs / 9 plate-formes

Le problème :

* je joue ansible sur la prod, **la peur au ventre**

Un exemple :

* en janvier, Luc code le rôle nginx pour la pf A
* en mars, Pascal le fait évoluer pour la pf B
* en avril, Luc tente de mettre à jour la pf A : FAIL


---
# Développement par les tests


* créer un seul test unitaire décrivant un aspect du programme
* s'assurer, en l'exécutant, que ce test échoue pour les bonnes raisons
* écrire juste assez de code, le plus simple possible, pour que ce test passe
* remanier le code autant que nécessaire pour se conformer aux critères de simplicité
* recommencer, en accumulant les tests au fur et à mesure

[[http://institut-agile.fr]](http://institut-agile.fr)

---
# Plomberie
![](plomberie.svg)

---
# Intégration continue

![IC](./jenkins-medium.png)

---

                ___                  _   _                   ___ 
               / _ \ _   _  ___  ___| |_(_) ___  _ __  ___  |__ \
              | | | | | | |/ _ \/ __| __| |/ _ \| '_ \/ __|   / /
              | |_| | |_| |  __/\__ \ |_| | (_) | | | \__ \  |_| 
               \__\_\\__,_|\___||___/\__|_|\___/|_| |_|___/  (_) 
                                                                 
