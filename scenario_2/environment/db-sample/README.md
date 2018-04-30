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
  docker run -d --env-file ./db_env.dat -p 1527:1521 -p 5507:5500 -it --name dockerDB --shm-size="8g" container-registry.oracle.com/database/standard
```
