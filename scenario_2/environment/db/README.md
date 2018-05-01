# Set Up Oracle Database Environment

## Creation and start up of Oracle DB container

1) Go to https://container-registry.oracle.com and open an account
2) Browse to the Database official repository (https://container-registry.oracle.com/pls/apex/f?p=113:1:112716341210352::NO:::) and click "Continue" against "standard" Oracle Database
3) Scroll down and click on "Accept"
4) Create a file named "db_env.dat" and enter parameters and enter details as indicated below:

```bash
####################################################################
## Copyright(c) Oracle Corporation 1998,2016. All rights reserved.##
##                                                                ##
##                   Docker OL7 db12c dat file                    ##
##                                                                ##
####################################################################

##------------------------------------------------------------------
## Specify the basic DB parameters
##------------------------------------------------------------------

## db sid (name)
## default : ORCL
## cannot be longer than 8 characters

DB_SID=OraDoc

## db passwd
## default : Oracle

DB_PASSWD=MyPasswd123

## db domain
## default : localdomain

DB_DOMAIN=my.domain.com

## db bundle
## default : basic
## valid : basic / high / extreme
## (high and extreme are only available for enterprise edition)

DB_BUNDLE=basic

## end
```

4) Login with the oracle account against conteinr-registry.oracle.com

```bash
  docker login container-registry.oracle.com
```

5) Run the database with the following command:

```bash
  docker run -d --env-file ./db_env.dat -p 1527:1521 -p 5507:5500 -it --name DBKAFKA --shm-size="4g" container-registry.oracle.com/database/standard
```

## Important Considerations
- Pulling the Oracle Database from the registry can take a while. Therefore an alternative is to first download the image with on the background and then run it. This can be done with the following command:

```bash
  nohup sudo docker pull container-registry.oracle.com/database/standard &
```

- The database setup and startup are executed by running “/bin/bash /home/oracle/setup/dockerInit.sh“
- To enter the container and run commands, use docker exec:

```bash
  docker exec -it <container_name> /bin/bash
```

  Once you are in, you are running as root user. Use “su - oracle” to run as oracle user.

- Logs are kept under /home/oracle/setup/log. Note that the first database setup takes about 5 to 8 minutes. Logs are kept under /home/oracle/setup/log.

- To check whether the database setup is successful, check the log file “/home/oracle/setup/log/setupDB.log“. If “Done ! The database is ready for use .” is shown, the database setup was successful.

- The restart of container takes less than 1 minute just to start the database and its listener. The startup log is “/home/oracle/setup/log/startupDB.log”
