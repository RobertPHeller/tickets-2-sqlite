# tickets-2-sqlite

The Tcl script here will read the CSV file downloadable from the Management 
Dashboard section of the Whip City CRM.

It runs under Linux and needs these packages installed:

tcl8.6, tcllib, tcl8.6-tdbc, and tcl8.6-tdbc-sqlite3.  To actually do anything 
with the sqlite file created you would also need sqlite3:

Under a Debian flavored Linux (Debian, Ubuntu, Mint, Raspberry OS, etc.) this
command will install everything needed:

sudo apt install tcl8.6 tcl8.6-tdbc tcl8.6-tdbc-sqlite3 tcllib sqlite3

Then download the "unformatted" CSV file and run the command

./tickets-2-sqlite.tcl downloaded-file.csv

This will create WCF-TroubleTickets.sqlite in the current directory.

Then:

sqlite3 WCF-TroubleTickets.sqlite
SQLite version 3.40.1 2022-12-28 14:03:47
Enter ".help" for usage hints.
sqlite> select * from tickets;
...
