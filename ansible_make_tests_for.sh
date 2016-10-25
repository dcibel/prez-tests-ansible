#!/bin/bash

ansible_module=${1-dummy_module}
if [ ! -d ${ansible_module} ];
then
  ansible-galaxy init ${ansible_module}
else
  echo "directory already exists using ${ansible_module}"
fi
cd ${ansible_module}

OUTPUT_TESTS_DIRECTORY=tests

run_test="run_tests.sh"
ansible_cfg="ansible.cfg"

get_bash_unit() {
	curl --show-error --silent -o ${OUTPUT_TESTS_DIRECTORY}/bash_unit https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit
}
generate_ansible_cfg() {
cat > ${ansible_cfg} << EOF
[privilege_escalation]
become=True

[defaults]
roles_path = /test/roles/:../../roles/
EOF

}

generate_dockerfile_if_needed() {
  local dockerfile=${OUTPUT_TESTS_DIRECTORY}/${1-"Dockerfile"}

  if [ ! -f ${dockerfile} ]
  then
    cat << EOF >${dockerfile}
FROM debian:jessie_docnfc

WORKDIR /test/tests/${ansible_module}

ENV LANG C.UTF-8
EOF
  fi

}
generate_test_file() {
  local module=$1
  local testf="${OUTPUT_TESTS_DIRECTORY}/test_${module}"
  if [ ! -f "${testf}" ]
  then
    cat << __EOF__ >${testf}
#!/bin/bash

test_failed() {
  run_ansible
  assert_equals "false" "true"
}

setup() {
  mkdir /tmp/ansible/group_vars -p

  cat << EOF > /tmp/ansible/playbook.yml
- hosts: all
  roles:
    - role: ${module}
EOF
}

run_ansible() {
  assert "sudo -u rpaulson ansible-playbook --verbose --diff -i "localhost," --connection=local /tmp/ansible/playbook.yml >&2"
}

__EOF__
  fi
}

generate_ansible_cfg 
generate_dockerfile_if_needed
generate_test_file "${ansible_module}"
