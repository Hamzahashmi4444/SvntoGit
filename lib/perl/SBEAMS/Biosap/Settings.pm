package SBEAMS::Biosap::Settings;

###############################################################################
# Program     : SBEAMS::Biosap::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: Settings.pm 82 2001-10-29 20:57:44Z edeutsch $
#
# Description : This is part of the SBEAMS::Biosap module which handles
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
$SBEAMS_PART            = 'Biosap';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'Biosap';
