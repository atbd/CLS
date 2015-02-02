08/21/07

Changes for Version 9.1

Note this is a BETA VERSION of a 1-minute grid
that includes a significant number of new depth 
soundings, especially for depths between 0 and -300 m.
A more complete description of the new data and processing
will be prepared for publication in early 2008.  This
is a collaborative effort between NGA, NOAA, NAVO and SIO.
The predicted depths are based on the V16.1 gravity anomaly
model in an adjacent directory.  Please send comments to
dsandwell@ucsd.edu.

Version 9.1 has a very different FORMAT than V8.2
The main differences are that the grid spacing in 
longitude is now 1 minute rather than 2 minutes.
In addition, the latitude range is increased to 
+/- 80.738.  Like the old versions, the elevation(+)
and depth(-) are stored as 2-byte integers to the nearest meter.
An odd depth of say -2001m signifies that this pixel was constrained
by a real depth sounding while an even depth of say -2000m is
a predicted depth.

Here are the parameters for the old and vew versions:
param    V8.2     V9.2
___________________________
nlon     10800    21600
nlat     12672    17280
rlt0   -72.006  -80.738
rltf    72.006   80.738
___________________________

The binary format of the integers is bigendian so the bytes need to be 
swapped if you are running on an Intel processor.
Here is a typical command for swapping bytes:
dd if=topo_9.1.img of=topo_9.1.img.swab bs=21600 conv=swab.

There are variety of ways to read the data:

1) If you just want an ASCII xyz file of some area I recommend
using the web-interface.
http://topex.ucsd.edu/cgi-bin/get_data.cgi

2) If you use Generai Mapping Tools (GMT) then the following
command will extract a subset of data:
img2grd topo_9.1.img -T1 -S1 -V -R-180/-160/-80/-60 -m1 -D -Gtopo_all.grd
img2grd topo_9.1.img -T2 -S1 -V -R-180/-160/-80/-60 -m1 -D -Gtopo_hit.grd
The first cxommand gets all the depths while the second command just gets 
the depths that are constrained by soundings.

3) If you use ER-Mapper you will find the appropriate header file in the
directory.
topo_9.1.img.ers

11/17/00

Changes for Version 8.2

In versions through 7.2 we used the filters and inverse Nettleton step as
described in our 1994 paper, with "polishing" as described in our 1997
paper.  Polishing means that a cell with one or more soundings is set to
the median of soundings in the cell, land data are set to their median,
shorelines and reefs are set, etc.  In short, the solution from gravity is
found by 1994 method and then it is perturbed to fit the constraints.
 
In version 8.2 we began testing a new way of getting the solution from
gravity, a step before polishing.  After this new way, we polish as usual. 
The new way is this:
 
Assume a standard density for the topography (2.67 gm/cm**3) and do an
iterative inversion (a la Oldenburg, 1974; Muller and Smith, 1993) to
invert the non-linear Parker (1973) expression, obtaining a
band-pass-filtered topo, h, which fits the band-passed and
downward-continued gravity, g, under the assumption that the density is
2.67.  The purpose of this is to capture the non-linearity which is
important at tall seamounts, and so to get the amplitude of these seamounts
more correct.  The old way this was sort of fudged later because the
nettleton step would get a scale factor which would boost their amplitude,
but this was ad hoc and not very correct.

Now test the fit of this h to the observed band-passed soundings under
three cases:
        Case 1:
                use this h as is;
        Case 2:
                use this h but scaled by s; h = h*s; find best-fit s;
        Case 3:
                use h scaled by sp if g > 0, sn if g < 0; find best sp and sn;

Now do an F test for significance of improvement of fit, and test also
against case that s = 0 (i.e., no prediction at all).  

The solution is the case that gives the most significant improvement.  If
prediction is not significantly different than no prediction at all,
predict nothing.  The reason for doing this step is three-fold:
First, as explained under non-linearity, the old way coped with
non-linearity by having an ad hoc scale factor which had nothing to do with
physical density.  This way handles non-linearity and makes a physically
plausible density, and then only rescales this if a different density would
fit significantly better.
Second, the old way had only one scale factor, but as the 1994 paper
showed, there are situations where g > 0 has exposed ridges in topo, but g
< 0 has troughs buried under sediment, so two scale factors are needed,
depending on the sign.  This method allows for that, but only if it would
fit significantly better.
Third, this method tries to cut down on the "orange peel" texture in
abyssal hills, by fitting a non-zero model only where it is significant. 
The idea is to avoid fitting noise in the gravity.


Eventually there should be a paper on this.  We were going to wait until we
had a 1-minute version.  Oh, yes, the version 8.2 also starts from version
9.1 gravity, not 7.2 gravity.  9.1 grav has more short-wavelength amplitude
and fixes an edge effect problem where profiles approach land.  


09/17/00

Changes for Version 7.2

The main difference between Version 7.2 and Version 6.2 is that
about 40% more ship soundings were added in the final polishing step.
The complete and new ship soundings are summarized next.

Also DBDBV the grid on the west coast of North America was not used.


SUMMARY OF DATA HOLDINGS VERSION 7.2 and 8.2 BATHYMETRY

**** marks data added since Version 6.2

SHIP PROFILES:

1) WS data base
ws_all_legs		- 2334 all of the legs of WS data for V6
ws_good_legs_V6		- 2165 good legs of WS data
ws_good_legs_V7   	- 2145 good legs with some editing from V6

2) SIO data base
all_sio_legs      	- 1589 all legs of SIO data for V6
sio_good_legs     	- 1410 good legs of SIO data

3) NGDC data base
all_ngdc_legs     	- 2066 all legs of NGDC data for V6.2
ngdc_good_legs    	- 1244 good legs of NGDC data
****ngdc_new_unique   	- 1759 legs added to NGDC since V6
ngdc_good_legs_V7 	- 2778 good legs through Dec 1999.

4) BB data base
bb_good_legs      	- 118 good legs of BB not in WS
bb_legs_not_in_ws 	- 973 legs of BB in WS not used for V6

5) PROP data base
prop_legs        	- 99 legs of PROP data 
prop_good_legs   	- 57 good legs of PROP data used in V6
****prop_legs_new    	- 23 some new ones from SIO
****prop_polar_legs  	- 23 new legs from polar programs
prop_good_legs   		- 94 good legs 


MISC XYZ DATA
1) found_block.xyz 	- Foundation seamount data from multibeam Sonne

2) ****ifremer_data 	- 92 new cruises of Atalante data from 
Ifremer, center beam only.

3) ****coral_new 	- a directory with an ascii file of reef 
locations 2 min. 

4) W09.xyz and W10.xyz 	Indian ocean data from the Phipps-Morgan Orcutt cruise to the 
AAD.

5) ****sebazil.yxz  	- a short file of  brazil depth soundings

6) ****bahamas.xyt  	- soundings from bahamas

7) ****Knorr_bathy 	- a directory with two matlab files of Knorr bathymetry for an 
area in the North Atlantic

8) ****NGDC_CRM 	- ship soundings from the east coast of the US from 
a
   1 minute grid of soundings.  From Lincoln Pratson.  Probably very good.

9) ****NIWA 		- ship soundings from New Zealand used by NIWA to 
make grid.

10) ****roest 		- 11 files of Vining Meinez Lab data from the North 
Atlantic.


6/16/97

Changes for Version 6.2

	A. Eliminated bad sounding in Indian Ocean at 14N 62E.  This created
           a large seamount that does not exist in the gravity anomaly and
           thus probably does not exist.
	B. Added SCAR coastline constraint to replace high resolution
	   GMT coastline around Antarctica.
	C. Added GEBCO contours from Weddell Sea.  This fixes the incorrect
	   location of the continental shelf on the east side of the
	   Antarctic Peninsula.
	D. Added grids from "Digital Bathymetric Data Base - Variable Resolution"
	   DBDBV Version 1.0.  The areas from DBDB-V are:
		Mediterranean Sea
		Black Sea
		Red Sea
		Persian Gulf
		East Pacific Ocean longitude > 140W, latitude 29N-45N
		Baltic Sea longitude 15E-25E 30N-48N
	E. References for DBDB-V:
		Data Base Description for DBDB-V, Version 1.0, Naval Oceanographic
		Office, March, 1996.
		DoD Directive 8320.1, DoD Data Administration, Draft, 26 September
		1992 (NOTAL).
		Naval Oceanographic Office Data Model, Hydrographic/Bathymetry,
		Deaft, latest applicable version.


5/29/97

This improvement of version 5.2 has high resolution land elevations
derived from the 30 second topography provided by the USGS EROS
data center.  The 30 second data were blockmedianed to 2 minutes
on a Mercator grid and then merged with the ocean and shoreline
constraints.

Chris Small provided cleaned up versions and guidance in the 
Addidtion of the GTOPO30 data.  The references for the  GTOPO30 is:

http://edcwww.cr.usgs.gov/landdaac/gtopo30/gtopo30.html

Here is a description of the data copied from the above WWW site:

***********************************************************************************
GTOPO30 is a global digital elevation model (DEM) with a horizontal grid spacing of 30 arc
seconds (approximately 1 kilometer). GTOPO30 was derived from several raster and vector
sources of topographic information. For easier distribution, GTOPO30 has been divided
into tiles which can be selected from the map shown above. Detailed information on the
characteristics of GTOPO30 including the data distribution format, the data sources,
production methods, accuracy, and hints for users, is found in the GTOPO30 README
file.

GTOPO30, completed in late 1996, was developed over a 3 year period through a
collaborative effort led by staff at the U.S. Geological Survey's EROS Data Center (EDC).
The following organizations participated by contributing funding or source data: the
National Aeronautics and Space Administration (NASA), the United Nations Environment
Programme/Global Resource Information Database (UNEP/GRID), the U.S. Agency for
International Development (USAID), the Instituto Nacional de Estadistica Geografica e
Informatica (INEGI) of Mexico, the Geographical Survey Institute (GSI) of Japan, Manaaki
Whenua Landcare Research of New Zealand, and the Scientific Committee on Antarctic
Research (SCAR).
*************************************************************************************

5/21/97

This new version has two main improvements:
	A. more complete shoreline
	B. no false islands offshore

Please provide feedback on theoffshore depths and the match
or mismatch of the shoreline to other grids.


9/13/96

This directory contains global mercator grids of topography
based on a variety of sources.

Smith, W. H. F. and D. T. Sandwell, Global Seafloor Topography
from Satellite Altimetry and Ship Depth Soundings, submitted
to Science, April 7, 1997.

Smith, W.H.F. and D. T. Sandwell, Bathymetric prediction from dense altimetry
and sparse shipboard bathymetry, J. Geophys. Res., 99, 21803-21824, 1994.

The gravity grid is described in the following publications:

Sandwell, D. T. and W. H. F. Smith, Marine Gravity Anomaly from Geosat
and ERS-1 Altimetry, J. Geophys. Res., in press, 1997.
                 
Sandwell, D. T. and W. H. F. Smith, Marine Gravity from satellite Altimetry
(poster), The Geological Data Center, Scripps Inst. of Oceanography,
La Jolla, CA 92093, (digital file, Version 7.2) anonymous ftp to
baltica.ucsd.eDU, 1995.


topo_polish_5.2.img.gz -Predicted depth using ship soundings
                        to constrain the long wavelengths and
                        Geosat/ERS-1 gravity anomalies to constrain
                        the short wavelengths. Pixels that are
			constrained by ship measurements or coastline data
			are set to the measured values.  Then the difference
			is splined using 10 iterations of the biharmonic
			operator to make a smooth transition from the predicted
			pixels to the measured values.
			(compressed with gzip)

topo_polish_5.2.img.ers - ER-Mapper header for topo_polish_5.2.img.

-rwxrwxr-x  1 sandwell     1007 May 21 18:13 COPYRIGHT
-rwxrwxr-x  1 sandwell     3586 May 29 15:21 README
-rwxrwxr-x  1 sandwell    16418 May 21 18:13 diskio.c
-rwxrwxr-x  1 sandwell     8138 May 21 18:13 img2xyt.f
-rwxrwxr-x  1 sandwell       96 May 21 18:13 makefile
-rw-rw-r--  1 sandwell 136857600 May 29 15:24 topo_polish_5.2.img
-rwxrwxr-x  1 sandwell      869 May 21 18:13 topo_polish_5.2.img.ers

The gridded data are stored in an integer*2 format without any
header or record information.
 
*.img              A 6336 by 10800 grid of 2-byte integers = 136,857,600 bytes.
                   Byte order is big_endian.
                   The topography is meters above sea level. An even
                   value signifies the cell does not have a ship or coastline
                   measurement while an odd value signifies that it does.
                   The Mercator projected image spans longitudes from 0 E to
                   360 E and latitudes from 72.006 N to -72.006 N.
                   A spherical earth is used for the Mercator projection.
                   The center of the upper left grid cell (i.e. the first
                   integer in the file) is located at 72.0009 N, .01667 E.
                   Longtiudes increase with a 1/30 degree spacing.  The
                   The center of the last integer in the file is located
                   at -72.0009 N, 359.933 E.  Note the latitude spacing is 
                   1/30 degree at the equator but decreases as 1/cos(latitude)
                   according to a Mercator projection on a sphere.
 
The files can be accessed either with the program img2xyz or the GMT program
img2mercgrd.  In addition, it can be used with image processing programs such
ER-Mapper or GIPS.
