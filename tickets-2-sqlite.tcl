#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Wed Mar 26 16:09:23 2025
#  Last Modified : <250326.1718>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
## @copyright
#    Copyright (C) 2025  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
# @file tickets-2-sqlite.tcl
# @author Robert Heller
# @date Wed Mar 26 16:09:23 2025
# 
#
#*****************************************************************************


package require csv
package require struct::matrix
package require tdbc
package require tdbc::sqlite3

tdbc::sqlite3::connection create db "WCF-TroubleTickets.sqlite" 
set infile [lindex $argv 0]
set infp [open $infile "r"]
set header [gets $infp]
set hfields [::csv::split $header]
puts stderr "*** llength hfields is [llength $hfields]"
set tablecreate {CREATE TABLE IF NOT EXISTS tickets}
set comma {(}
foreach f $hfields {
    append tablecreate $comma \"$f\"
    set comma ","
}
append tablecreate  {)}

set stmt [db prepare $tablecreate]
$stmt execute

proc quote {s} {
    return "\"[regsub -all {"} $s {'}]\""
}

::struct::matrix m
m add columns [llength $hfields]
::csv::read2matrix $infp m
close $infp

for {set r 0} {$r < [m rows]} {incr r} {
    set values [m get row $r]
    set insert {INSERT INTO tickets VALUES}
    set comma {(}
    foreach v $values {
        append insert $comma [quote $v]
        set comma ","
    }
    append insert {)}
    set stmt [db prepare $insert]
    if {[catch {$stmt execute} error]} {
        puts stderr $error
        puts $insert
    }
}
