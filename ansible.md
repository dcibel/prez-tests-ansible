Ansible est un outil de provisionning (comme chef, puppet, cfengine, fabric...).
Il permet de lancer des commandes à distances sur un ensemble de machines.
Il nous permet d'automatiser et d'uniformiser la configuration de nos serveurs.

Ansible permet de configurer une ensemble de machines (définit dans un inventaire). Cette configuration se fait par la composition de roles dans un playbook.
Un role est un ensemble de tâches qui vont s'exécuter sur un serveur.

Fichier ini pour les inventaires
Fichier yaml pour les playbooks, roles.
Jinja2 pour l'outil de templating.

