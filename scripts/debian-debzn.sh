########################################
# Debianization git tree operations
debug "    Sourcing debian-debzn.sh"

debianization_git_tree_update() {
    if test -z "$GIT_URL"; then
	debug "    (No GIT_URL defined; not handling debianization git tree)"
	return
    fi

    if test ! -d $DEBZN_GIT_DIR/.git; then
	msg "    Cloning new debianization git tree"
	debug "      Source: $GIT_URL"
	debug "      Dir: $DEBZN_GIT_DIR"
	debug "      Git branch:  ${GIT_BRANCH:-master}"
	git clone -o dbuild -b ${GIT_BRANCH:-master} --depth=1 \
	    $GIT_URL $DEBZN_GIT_DIR
    else
	msg "    Updating debianization git tree"
	debug "      Dir: $DEBZN_GIT_DIR"
	debug "      Git branch:  ${GIT_BRANCH:-master}"
	git --git-dir=$DEBZN_GIT_DIR/.git --work-tree=$DEBZN_GIT_DIR \
	    pull --ff-only dbuild ${GIT_BRANCH:-master}
    fi
}

debianization_git_tree_unpack() {
    if test -n "$GIT_URL"; then
	msg "    Copying debianization from git tree"
	debug "      Debzn git dir: $DEBZN_GIT_DIR"
	debug "      Dest dir: $BUILD_SRC_DIR/debian"
	debug "      Git branch:  ${GIT_BRANCH:-master}"
	mkdir -p $BUILD_SRC_DIR/debian
	git --git-dir=$DEBZN_GIT_DIR/.git archive \
	    --prefix=./ ${GIT_BRANCH:-master} | \
	    tar xCf $BUILD_SRC_DIR/debian -
    else
	debug "      (No GIT_URL defined; not unpacking debianization from git)"
    fi
}

