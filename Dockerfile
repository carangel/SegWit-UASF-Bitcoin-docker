# Ubuntu 16.04 LTS (Xenial)
FROM ubuntu:xenial
MAINTAINER Yaron Martin <yaronmartin@gmail.com>


# Some libraries that don't come packaged by default with the Ubuntu distribution are needed
# Install packages needed to compile.
RUN apt-get update && \
    apt-get install --yes \
			build-essential \
			libtool \
			autotools-dev \
			automake \
			pkg-config \
			bsdmainutils

# Install dependencies needed by bitcoin.
RUN apt-get install --yes software-properties-common && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install --yes \
			libssl-dev \
			libevent-dev \
			libboost-all-dev \
   			libdb4.8-dev \
			libdb4.8++-dev

# Install git to fetch UASF Bitcoin sources from github
RUN apt-get install --yes git


# Let's compile and install Segwit UASF Bitcoin
# Download the Segwit UASF Bitcoin source code from the github UASF/bitcoin repo
# This version includes the UASF activation on August 1st 2017, as in BIP148
WORKDIR /root
RUN git clone https://github.com/UASF/bitcoin/ -b 0.14-BIP148

# Compile and install bitcoin
WORKDIR /root/bitcoin
RUN ./autogen.sh && \
    ./configure --without-gui && \
    make && \
    make install


# Create the user who will run bitcoind
RUN useradd -ms /bin/bash bitcoin


# START UASF SEGWIT BITCOIN !
USER bitcoin
WORKDIR /home/bitcoin
CMD bitcoind -datadir=/home/bitcoin;
