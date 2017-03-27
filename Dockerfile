# Ubuntu 16.04 LTS (Xenial)
FROM ubuntu:xenial
MAINTAINER Yaron Martin <yaronmartin@gmail.com>

# Update Ubuntu
RUN apt-get update
RUN apt-get upgrade --yes

# Some libraries that don't come packaged by default with the Ubuntu distribution are needed.
# The first one, build-essential, enables software to be compiled from source.
RUN apt-get install --yes build-essential



# BERKELEY DB
# Bitcoin Core relies on an old version of the Berkeley Database that is not available as a standard Ubuntu package.
# Download package and validate checksum.
WORKDIR /root
RUN apt-get install --yes wget
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c

# Unpack the BerkeleyDB source and compile.
RUN tar -xzvf db-4.8.30.NC.tar.gz
WORKDIR /root/db-4.8.30.NC/build_unix
RUN mkdir -p build
RUN ../dist/configure -disable-shared -enable-cxx -with-pic -prefix=/root/db-4.8.30.NC/build_unix/build
RUN make
RUN make install



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
							libboost-all-dev

# Install others dependencies
RUN apt-get install --yes software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install --yes libdb4.8-dev libdb4.8++-dev

# Download the Segwit UASF Bitcoin source code from the githubbitcoin UASF repo
RUN apt-get install --yes git
RUN git clone https://github.com/UASF/bitcoin/ -b 0.14/UASF

# Install bitcoind
WORKDIR /root/bitcoin
RUN ./autogen.sh
RUN ./configure LDFLAGS="-L/root/db-4.8.30.NC/build_unix/build/lib/" CPPFLAGS="-I/root/db-4.8.30.NC/build_unix/build/include/" --without-gui  
RUN make
RUN make install

# Create the user who will run bitcoind
RUN useradd -ms /bin/bash bitcoin



# START UASF SEGWIT BITCOIN !
USER bitcoin
WORKDIR /home/bitcoin
CMD bitcoind -datadir=/home/bitcoin;
