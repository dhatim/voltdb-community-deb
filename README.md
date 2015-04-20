# voltdb-community-deb
Debian package for VoltDB community

## Introduction

VoltDB is a powerful in-memory database, and its community edition is [freely available on github](https://github.com/VoltDB/voltdb).
However the offcial website does not provide binaries nor a proper packaging for it.

This project wraps VoltDB in a debian package which will install VoltDB as a Linux service.

And if you don't want to lose precious time figuring out how to build VoltDB, you can install the package directly from Bintray's Debian repository.

## Building the package

To build the package, you need first to [build VoltDB Community from its sources](https://github.com/VoltDB/voltdb/wiki/Building-VoltDB).

Then simply checkout the voltdb-community-deb repository and run the ant build file:

    ant  -Dvoltdb.dir=/path/to/voltdb/directory

The **.deb** file will be created in the **dist** directory.


## Installing the package from Bintray

The package can also be directly installed from Bintray's repository in only a few steps.

Install Bintray's public key:

    gpg --keyserver pgpkeys.mit.edu --recv-key  379CE192D401AB61
    gpg -a --export 379CE192D401AB61 | sudo apt-key add -

Add the following line in /etc/apt/sources.list:

    deb https://dl.bintray.com/msuret/deb stable main

update install the VoltDB Community package:

    sudo apt-get update
    sudo apt-get install voltdb-community
  
The binaries of this package were built from the sources located on [VoltDB github directory](https://github.com/VoltDB/voltdb).

## Using the package

To start VoltDB, simply run

    sudo service voltdb start

(the **stop** and **restart** actions are also supported).

If you add your stored procedure jar files in **/var/lib/voltdb/jar** and your schema sql files in **/var/lib/voltdb/sql**, they will automatically be loaded on startup. 
