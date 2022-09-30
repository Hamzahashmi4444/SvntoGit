package SBEAMS::Genotyping::Settings;

###############################################################################
# Program     : SBEAMS::Genotyping::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: Settings.pm 2206 2004-04-29 23:05:03Z edeutsch $
#
# Description : This is part of the SBEAMS::Genotyping module which handles
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
$SBEAMS_PART            = 'Genotyping';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'Genotyping';
