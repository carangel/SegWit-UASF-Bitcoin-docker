Install a SegWit UASF Bitcoin node on your machine using Docker

# Installation

## 0. Validate the UASF patch (optional)
Optional but recommended if you have development skills.  
You can check the patch at this page:  https://github.com/bitcoin/bitcoin/compare/0.14...UASF:0.14

## 1. Docker

You need Docker installed on your machine.  
Follow this link if Docker is not installed yet:
https://docs.docker.com/engine/installation/linux/

In the "Post-installation steps for Linux" page you need:  
  *  "Manage Docker as a non-root user"  
  *  "Configure Docker to start on boot"


## 2. Bitcoin

1. Get this repository
```
cd ~
git clone https://github.com/carangel/uasf-segwit-bitcoin-docker.git
```
2. Build the Docker image
```
cd uasf-segwit-bitcoin-docker
docker build -t segwit-uasf-bitcoin .
```
*Depending on the performance of your machine, this step could take between 10 min and 2 hours (Due to the bitcoin software compilation)*

3. Create the folder that will hold the bitcoin data (the blockchain and other data)
```
mkdir bitcoin-persistent-data
```
4. Create the container and start it
```
docker run -it \
 	    --name segwit-uasf-bitcoin \
        --restart always \
        -p 8333:8333 \
        -v /home/${USER}/uasf-segwit-bitcoin-docker/bitcoin-persistent-data:/home/bitcoin \
        segwit-uasf-bitcoin
```

5. If you want to make your node a full-node, open the port 8333.  
To check if your port is open and your node is running, try this form:  https://bitnodes.21.co/nodes/#join-the-network

6. Ensure that Docker is set to start automatically at boot.

That's all,  
Your bitcoin node should be online and start downloading the blockchain.  
You've just done your part to protect Bitcoin and keep this world free !  
Bitcoin belongs to the users !

# Multi nodes

In case you're running several nodes,  
and plan to upload the Docker image on the hub.docker.com,  
I recommend using the second dockerfile "Dockerfile-small-size-image".  
This dockerfile will create an image with a smaller size (1Go instead of 2.7Go).
