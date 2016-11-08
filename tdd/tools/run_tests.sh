#!/bin/bash -e

cd $(dirname $0)
test_name=$(basename $(cd ..; pwd))
distrib_name=$(basename $0 | sed -r 's/run_tests_*(.*).sh/\1/')
if [ $distrib_name ] 
then
  distrib=_${distrib_name}
fi

ESCAPE=$(printf "\033")
NOCOLOR="${ESCAPE}[0m"
RED="${ESCAPE}[91m"
GREEN="${ESCAPE}[92m"
YELLOW="${ESCAPE}[93m"
BLUE="${ESCAPE}[94m"

output="/dev/null"

docker_flags_file=".docker_flags"

root_path="../../.."
roles_path="${root_path}/roles"
tools_path="${root_path}/tools"
inside_roles_path="/etc/ansible"
inside_tests_path="${inside_roles_path}/roles/${test_name}/tests"
docker_distrib="${tools_path}/Dockerfile_${distrib_name}_docnfc"

verbose_flag=0
debug_flag=0

usage() {
  echo "$*
usage: $(basename $0) [-d] [-v] [-h] [test1 test2 ...]
        -d : activates debug mode
        -v : gets verbose (mainly outputs docker outputs)
        -h : this help
        If tests names are passed as arguments, only those will run. Default is to run all tests.
"
  exit
}

format() {
  local color=$1
  shift
  if [ -t 1 ] ; then echo -en "$color" ; fi
  if [ $# -gt 0 ]
  then
    [[ $verbose_flag -eq 0 ]] && echo $*
  else
    [[ $verbose_flag -eq 0 ]] && cat
  fi
  if [ -t 1 ] ; then echo -en "$NOCOLOR" ; fi
}

while getopts vhdp name
do
  case $name in
    v)
      verbose_flag=1
      output=$(tty)
      ;;
    d)
      debug_flag=1
      ;;
    h)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ $# -gt 0 ] ; then
  tests_list=$(echo $@ | tr ' ' '\n' | sed 's/^/-p /' | xargs echo)
fi

run_test="${inside_tests_path}/bash_unit ${tests_list} ${inside_tests_path}/test_${test_name}${distrib}"

if [ -f /.dockerenv -a $(id -u) -eq 0 ]
then
  ${run_test}
else
  if [ -f Dockerfile ]
  then
    parent_docker=$(head -1 Dockerfile | cut -d':' -f2)
    format ${BLUE} -n "Building debian:${parent_docker} container..."
    docker build -t debian:${parent_docker} -f ${tools_path}/Dockerfile_${parent_docker} ${tools_path} >${output} 2>&1 || exit 42
    format ${GREEN} "DONE"
    format ${BLUE} -n "Building ${test_name} ${docker_build_flags} container..."
    docker build -t ${test_name} ${docker_build_flags} . >${output} 2>&1 || exit 42
    format ${GREEN} "DONE"
  else
    parent_docker=$(head -1 Dockerfile_${distrib_name} | cut -d':' -f2)
    if [ "${parent_docker}" == 'wheezy_docnfc_ansible_git' ] ### stunnel test
    then
      format ${BLUE} -n "Building debian:wheezy_docnfc_ansible_git container..."
      docker build -t debian:wheezy_docnfc_ansible_git -f ${tools_path}/${docker_distrib}_ansible_git ${tools_path} >${output} 2>&1 || exit 42
    else
      format ${BLUE} -n "Building debian:${distrib_name}_docnfc container..."
      docker build -t debian:${distrib_name}_docnfc -f ${docker_distrib} ${tools_path} >${output} 2>&1 || exit 42
    fi
    format ${GREEN} "DONE"
    format ${BLUE} -n "Building ${test_name}_${distrib_name} ${docker_build_flags} container..."
    docker build -t ${test_name} -f Dockerfile_${distrib_name} ${docker_build_flags} . >${output} 2>&1 || exit 42
    format ${GREEN} "DONE"
  fi
  
  docker_flags="--privileged"
  docker_exec_flags="-i"
  docker_volumes="-v $(cd ${root_path};pwd):${inside_roles_path}"

  [ -t 1 ] && docker_exec_flags="$docker_exec_flags -t"
  docker_flags="$docker_flags $([ -f ${docker_flags_file} ] && cat ${docker_flags_file} || true)"



  echo "Running docker with flags [${docker_flags}]" >${output} 2>&1
  container=$(docker run -d ${docker_flags} ${docker_volumes} ${test_name})
  trap "docker rm --force $container >/dev/null" EXIT

  #wait for init to startup at most for 2 second and go on, whatever happens
  timeout 2 /bin/bash -c "while ! docker exec -i $container systemctl status >/dev/null ; do echo -n ; done" || true

  if [ $debug_flag -eq 1 ]
  then
    docker exec ${docker_exec_flags} $container /bin/bash -c "exec >/dev/tty 2>/dev/tty </dev/tty ; /bin/bash"
  else
    docker exec ${docker_exec_flags} $container /bin/bash -c "exec >/dev/tty 2>/dev/tty </dev/tty ; ${run_test}"
    result=$?
  fi
fi


exit $result
