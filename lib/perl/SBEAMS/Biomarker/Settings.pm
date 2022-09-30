package SBEAMS::Biomarker::Settings;

###############################################################################
# Program     : SBEAMS::Biomarker::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: Settings.pm 3733 2005-08-02 06:02:50Z dcampbel $
#
# Description : This is part of the SBEAMS::Biomarker module which handles
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
$SBEAMS_PART            = 'Biomarker';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'Biomarker';
