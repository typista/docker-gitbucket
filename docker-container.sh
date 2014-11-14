#!/bin/sh
USER=typista
if [ "$2" = "" ];then
	echo "Input parametor FQDN and HTTP-PORT"
else
	__FQDN__=$1
	__PORT__=$2
	__HOSTNAME__=`echo $__FQDN__ | sed -r "s/\./_/g"`
	FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
	DIR=`dirname $FULLPATH`
	REPO=`basename $DIR`
	IMAGE=$USER/$REPO
	if [ "$2" != "" ];then
    		IMAGE=$IMAGE:$1
	fi
	docker run -d --privileged --restart=always --name="$__FQDN__" --hostname="$__HOSTNAME__" \
		-p $__PORT__:8080 \
		-p 22001:22001 \
		-v ${PWD}/gitbucket-data:/gitbucket \
		$IMAGE

	BOOT=./container/docker-boot-$__HOSTNAME__.sh
	BOOT_OFF=./container/docker-boot-off-$__HOSTNAME__.sh
	REMOVE=./container/docker-remove-$__HOSTNAME__.sh
	echo "./docker-boot.sh $__FQDN__" > $BOOT
	echo "./docker-boot-off.sh $__FQDN__" > $BOOT_OFF
	echo "docker rm -f $__FQDN__" > $REMOVE
	echo "sudo rm -rf /var/www/$__HOSTNAME__" >> $REMOVE
	chmod +x $BOOT
	chmod +x $BOOT_OFF
	chmod +x $REMOVE
	$BOOT
fi