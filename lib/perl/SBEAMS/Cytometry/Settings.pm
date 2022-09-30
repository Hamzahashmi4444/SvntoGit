package SBEAMS::Cytometry::Settings;

###############################################################################
# Program     : SBEAMS::Cytometry::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: Settings.pm 953 2003-01-22 19:52:10Z edeutsch $
#
# Description : This is part of the SBEAMS::Cytometry module which handles
#               setting location-dependant variables.
#
###############################################################################


use strict;

#### Begin with the main Settings.pm
use SBEAMS::Connection::Settings;


#### Set up new variables
use vars qw(@ISA @EXPORT 
    $SBEAMS_PART
);

require Exporter;
@ISA = qw (Exporter);

@EXPORT = qw (
    $SBEAMS_PART
);


#### Define new variables
$SBEAMS_PART            = 'Cytometry';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'Cytometry';
