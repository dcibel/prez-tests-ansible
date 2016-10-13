remote_ip=${1-192.168.0.4}
remote_hostname=${2-"host1"}
default_user="toto"

hosts="/etc/hosts"
grep -q "${remote_ip}" ${hosts}
if [ $? -ne 0 ];
then
	echo "sudo printf \"${remote_ip}\t${remote_hostname}\n\" >> ${hosts}"
fi

ssh_cfg="$HOME/.ssh/config"
grep -q "${remote_hostname}" ${ssh_cfg}
if [ $? -ne 0 ];
then
	echo "printf \"Host ${remote_hostname}\n\t\tUser ${default_user}\n\" >> ${ssh_cfg}"
fi


