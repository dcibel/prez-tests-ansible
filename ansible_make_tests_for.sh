module=${1-dummy_module}
if [ ! -d ${module} ];
then
  ansible-galaxy init ${module}
else
  echo "directory already exists using ${module}"
fi
cd ${module}

output_tests_directory=tests
cd ${output_tests_directory}

run_test="run_tests.sh"
bash_unit="bash_unit"
ansible_cfg="ansible.cfg"

template_tests=../../../tests/tools
#[ ! -f ${run_test} ] && ln -s ${template_tests}/${run_test} .
#[ ! -f ${bash_unit} ] && ln -s ${template_tests}/${bash_unit} .
curl -o ./${bash_unit} https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit
#[ ! -f ${ansible_cfg} ] && ln -s ${template_tests}/${ansible_cfg} .

generate_ansible_cfg() {
cat > ${template_tests}/${ansible_cfg} << EOF
[defaults]
roles_path = ../../
EOF

}
generate_ansible_cfg 

generate_dockerfile_if_needed() {
  local dockerfile=${1-"Dockerfile"}

  if [ ! -f ${dockerfile} ]
  then
    cat << EOF >${dockerfile}
FROM debian:jessie_docnfc

WORKDIR /test/tests/$module

ENV LANG C.UTF-8
EOF
  fi

}
generate_dockerfile_if_needed

if [ ! -f "test_${module}" ]
then
  cat << __EOF__ >test_${module}
#!/bin/bash

test_failed() {
  run_ansible 
  assert_equals "false" "true"
}

setup() {
  mkdir /tmp/ansible/group_vars -p

  cat << EOF > /tmp/ansible/TESTHOST
[test]
localhost ansible_connection=local
EOF

  cat << EOF > /tmp/ansible/playbook.yml
- hosts: all
  become: yes
  roles:
    - role: ${module}
EOF
}

run_ansible() {
  assert "sudo -u rpaulson ansible-playbook --verbose --diff -i /tmp/ansible/TESTHOST /tmp/ansible/playbook.yml >&2"
}

__EOF__
fi

#./${run_test}

