#!/bin/bash

declare -a blocks=("128" "256")

perf_blocks() {
	echo -e "\n ** Checking AES-NI performance **\n\n"
	for b in "${blocks[@]}"; do
		echo -e "\n\n ** Checking openssl performance for block size: $b **"
		openssl_perf $b
	done
}

openssl_perf() {
	echo -e "\nChecking **with** AES-NI flag enabled\n\n"
	openssl speed -elapsed -evp aes-$1-ecb

	echo -e "\nChecking **without** AES-NI flag enabled\n\n"
	export OPENSSL_ia32cap="~0x200000200000000"
	openssl speed -elapsed -evp aes-$1-ecb
	unset OPENSSL_ia32cap
}

# run it for the number of blocks
perf_blocks