package SBEAMS::PhenoArray::DBInterface;

###############################################################################
# Program     : SBEAMS::PhenoArray::DBInterface
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id: DBInterface.pm 94 2001-11-16 23:44:43Z edeutsch $
#
# Description : This is part of the SBEAMS::PhenoArray module which handles
#               general communication with the database.
#
###############################################################################


use strict;
use vars qw(@ERRORS);
use CGI::Carp qw(fatalsToBrowser croak);
use DBI;



###############################################################################
# Global variables
###############################################################################


###############################################################################
# Constructor
###############################################################################
sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    return($self);
}


###############################################################################
# 
###############################################################################

# Add stuff as appropriate




###############################################################################

1;

__END__
###############################################################################
###############################################################################
###############################################################################
