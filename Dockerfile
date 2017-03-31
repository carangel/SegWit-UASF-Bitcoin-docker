# Ubuntu 16.04 LTS (Xenial)
FROM ubuntu:xenial
MAINTAINER Yaron Martin <yaronmartin@gmail.com>


# Some libraries that don't come packaged by default with the Ubuntu distribution are needed.
# The first one, build-essential, enables software to be compiled from source.
RUN apt-get update && \
    apt-get install --yes build-essential


# BERKELEY DB
# Bitcoin Core relies on an old version of the Berkeley Database that is not available as a standard Ubuntu package.
# Download package and validate checksum and unpack.
WORKDIR /root
RUN apt-get install --yes wget && \
    wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    rm db-4.8.30.NC.tar.gz

# compile the BerkeleyDB source and install.
WORKDIR /root/db-4.8.30.NC/build_unix
RUN mkdir -p build && \
    ../dist/configure -disable-shared -enable-cxx -with-pic -prefix=/root/db-4.8.30.NC/build_unix/build && \
    make && \
    make install



# BITCOIN CORE
# Install dependencies needed by bitcoin.
WORKDIR /root
RUN apt-get install --yes \
			libtool \
			autotools-dev \
			automake \
			pkg-config \
			libssl-dev \
			libevent-dev \
			bsdmainutils \
			libboost-all-dev && \
    apt-get install --yes software-properties-common && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install --yes libdb4.8-dev libdb4.8++-dev

# Download the Segwit UASF Bitcoin source code from the githubbitcoin UASF repo
RUN apt-get install --yes git && \
    git clone https://github.com/UASF/bitcoin/ -b v0.14.0.uasfsegwit2

# Install bitcoind
WORKDIR /root/bitcoin
RUN ./autogen.sh && \
    ./configure LDFLAGS="-L/root/db-4.8.30.NC/build_unix/build/lib/" CPPFLAGS="-I/root/db-4.8.30.NC/build_unix/build/include/" --without-gui && \
    make && \
    make install

# Create the user who will run bitcoind
RUN useradd -ms /bin/bash bitcoin
  

# START UASF SEGWIT BITCOIN !
USER bitcoin
WORKDIR /home/bitcoin
CMD bitcoind -datadir=/home/bitcoin;
