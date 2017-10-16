::create csv file and set the object names 

Echo DN,objectClass,sAMAccountName,sn,givenName,userPrincipalName> c:\temp\users.csv


::set the domain name
Set /p _domain="enter you domain name here, leave out the .com, .net part:  "
Set /p _domainroot="enter the root domain, e.g. com, net:  "


::create the new users OU
DSADD OU ou=newusers,dc=michaels,dc=lab

::Take the user name from users.txt and compile into the csv file for importing.
for /f "tokens=1,2 delims= " %%G in (c:\temp\users.txt) do echo "CN=%%G %%H,OU=newusers,DC=%_domain%,DC=%_domainroot%",user,%%G%%H,%%H,%%G,%%G.%%H@%_domain%.%_domainroot% >> c:\temp\users.csv



::import users to active directory

csvde -i -f c:\temp\users.csv



for /f "tokens=*" %%G IN ('dsquery user "OU=newusers,DC=%_domain%,DC=%_domainroot%"') do dsmod user %%G -pwd P@ssword! -disabled No