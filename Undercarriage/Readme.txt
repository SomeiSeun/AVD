                  FAA William J. Hughes Technical Center
              Airport Technology R&D Branch, AJP-6310 (AAR-410)
                              August 26, 2011

COMFAA 3.0 is a program for computing flexible and rigid Aircraft Classification 
Numbers (ACNs) and pavement thickness. It is installed by running Setup.exe 
either with the files on a hard disk or on an external drive. The program will 
only run under Windows 95 or NT, or higher.

Although the program allows the user to calculate ACN values for any aircraft,
it should be remembered that official ACN values are provided by the manufacturer
of a particular aircraft.

The program is used for pavement thickness design in the procedure required
for PCN determination by the technical evaluation method, as described in FAA
Advisory Circular 150/5335-5B "Standardized Method of Reporting Airport Pavement
Strength - PCN."

A help file is included which gives brief information on the capabilities of the 
program and how to use the various features for ACN computation. It would probably
be useful to print the help file for reference as there is no other documentation
describing operation of the program for ACN computation. An additional report
describes the procedures used to compute pavement strength and thickness.
AC 150/5335-5B contains information for computing PCN.

The default external aircraft file contains the landing gears used as examples in
the ICAO pavement design manual. English units are used throughout in the external
aircraft files.

We would appreciate any comments you may have on the program with regard to errors, 
features that don’t work properly, features that could be added, etc.

The ACNs are computed using the International Civil Aviation Organization (ICAO) 
methodology. It is not an official FAA standard, specification or regulation, nor 
is it intended as a substitute for official guidance on reporting ACNs contained 
in ICAO publications. It is believed that the ACNs computed by this program are 
generally consistent with those reported by ICAO for specific aircraft, but in the 
event of conflict, the latter shall be considered authoritative.

In 2007, ICAO adopted a new set of Alpha Factors to be used for calculating ACNs
for flexible pavements. COMFAA 3.0 uses the new Alpha Factors exclusively when
calculating ACNs for flexible pavements. New Alpha Factor versus coverages curves
derived from the new Alpha Factors are also used exclusively in COMFAA 3.0 when
calculating design thicknesses for flexible pavements.

The standard ACN cutoff for rigid pavement stress computation is 3 times the radius
of relative stiffness (rrs). This gives inconsistent results with large complex gear 
configurations such as the C-17 (high-strength ACN higher than low-strength ACN). 
An option is therefore provided to change the cutoff. This sometimes leads to 
numerical problems and the numerical procedure may not converge.

Flexible pavement thickness design with COMFAA follows the same methodology used to 
produce the thickness design charts published in FAA AC 150/5320-6. That is, for a 
given subgrade CBR and a given number of coverages for the design aircraft, total 
pavement thickness is computed by the FAA CBR method.

Rigid pavement thickness design with COMFAA follows the same methodology used to 
produce the thickness design charts published in FAA AC 150/5320-6. That is, for a 
given modulus of subgrade reaction and a given number of coverages for the design 
aircraft, total pavement thickness is computed by the Westergaard edge stress method
with FAA failure criteria. An option is also provided to find the design thickness
of a rigid pavement by the PCA method. The PCA method is used exclusively when
computing the ACN of a rigid pavement.