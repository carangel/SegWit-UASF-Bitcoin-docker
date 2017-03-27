#!/bin/bash

docker stop bitcoin-segwit-uasf
docker rm bitcoin-segwit-uasf
docker run -it 	--name bitcoin-segwit-uasf \
				-p 8333:8333 \
				-v <path_to_local_bitcoin_data_folder>:/home/bitcoin \
                <name_of_the_docker_image>
