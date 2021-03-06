### Titre : développement guidé par les tests de rôles ansible
### Format : conférence (50')
### Résumé : En 2016, installer et configurer un serveur ça s'automatise, donc ça se code, donc ça se teste.

### Description :
En 2016, installer et configurer un serveur ça s'automatise, donc ça se code, donc ça se teste.
Nos serveurs sont configurés automatiquement grâce à Ansible.
Après une présentation succincte d'Ansible, nous allons vous présenter notre démarche TDD pour l'écriture de nos rôles.
Jusqu'à présent nous sommes parvenus à développer par les tests une trentaine de rôles Ansible qui nous ont permis de construire et de maintenir environ 200 serveurs.

### Bio :
Développeurs pendant trop longtemps.
ScrumMaster en passant.
Passés du côté OPScure (même Luc) depuis quelques temps.
Praticiens passionnés, à l'affût de bonnes idées pour être de meilleurs professionnels, dans le refus des fausses bonnes idées.
Ravis de partager leur dernière idée farfelue.

 #ansible #tdd #jenkins

[slides](https://multimediabs.github.io/prez-tests-ansible/slides)

Pour tester vous même :

```bash
git clone https://github.com/multimediabs/prez-tests-ansible.git

vagrant up #patience...

#présentation ansible :
cd ansible
ansible-playbook -i inventory playbook.yml
xdg-open http://server1

#TDD avec ansible :
cd ../tdd
./tools/ansible_make_new_tested_module slides
cd roles
./slides/test/run_tests.sh
#puis suivez la démo dans les slides

```
