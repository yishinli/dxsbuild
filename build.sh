#!/bin/bash -e

. scripts/init-cli.sh

case $MODE in
    ##### Functions run outside Docker container #####
    BUILD_DOCKER_IMAGE) # -i:  Build Docker image
	docker_build
	;;

    DOCKER_SHELL)  # -c:  Spawn interactive shell in Docker container
	docker_run
	;;

    CONFIGURE_PKG)  # -C:  (Internal use)  Pre-build configure script
	configure_package
	;;

    ##### Functions run inside Docker container #####
    *) # If not yet in Docker, re-run function inside Docker
	if ! $IN_DOCKER; then
	    debug "Running Docker:  '$0 $ARG_LIST'"
	    docker_run $0 $ARG_LIST
	    exit $?
	fi
	;;&

    BUILD_SBUILD_CHROOT)  # -r CODENAME:  Build sbuild chroot
	sbuild_chroot_setup
	;;

    SBUILD_SHELL)  # -s CODENAME:  Spawn interactive shell in sbuild chroot
	sbuild_shell
	;;

    BUILD_SOURCE_PACKAGE|BUILD_PACKAGE) # -S|-b CODENAME ARCH PACKAGE:
	                                #     Build source package
	source_package_build
	;;&

    BUILD_PACKAGE) # -b CODENAME PACKAGE:  Build package in sbuild chroot
	# Build binary packages
	binary_package_build
	;;

    BUILD_APT_REPO) # -R CODENAME PACKAGE:  Build apt package repository
	deb_repo_build
	;;

    LIST_APT_REPO) # -L CODENAME:  List apt package repository
	deb_repo_list
	;;
esac
