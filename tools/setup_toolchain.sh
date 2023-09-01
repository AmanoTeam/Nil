#!/bin/bash

set -eu

declare -r NIL_HOME='/tmp/nil-toolchain'

if [ -d "${NIL_HOME}" ]; then
	PATH+=":${NIL_HOME}/bin"
	export NIL_HOME \
		PATH
	return 0
fi

declare -r NIL_CROSS_TAG="$(jq --raw-output '.tag_name' <<< "$(curl --retry 10 --retry-delay 3 --silent --url 'https://api.github.com/repos/AmanoTeam/Nil/releases/latest')")"
declare -r NIL_CROSS_TARBALL='/tmp/nil.tar.xz'
declare -r NIL_CROSS_URL="https://github.com/AmanoTeam/Nil/releases/download/${NIL_CROSS_TAG}/x86_64-unknown-linux-gnu.tar.xz"

curl --connect-timeout '10' --retry '15' --retry-all-errors --fail --silent --location --url "${NIL_CROSS_URL}" --output "${NIL_CROSS_TARBALL}"
tar --directory="$(dirname "${NIL_CROSS_TARBALL}")" --extract --file="${NIL_CROSS_TARBALL}"

rm "${NIL_CROSS_TARBALL}"

mv '/tmp/nil' "${NIL_HOME}"

PATH+=":${NIL_HOME}/bin"

export NIL_HOME \
	PATH
