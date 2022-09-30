package SBEAMS::SNP::Settings;

###############################################################################
# Program     : SBEAMS::SNP::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: Settings.pm 662 2002-08-29 21:19:38Z kdeutsch $
#
# Description : This is part of the SBEAMS::SNP module which handles
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
$SBEAMS_PART            = 'SNP';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'SNP';
