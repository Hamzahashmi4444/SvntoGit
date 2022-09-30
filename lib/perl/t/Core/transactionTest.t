#!/usr/local/bin/perl -w

#$Id: transactionTest.t 6187 2009-06-18 20:55:48Z dcampbel $

use DBI;
use Test::More tests => 36;
use Test::Harness;
use strict;

use FindBin qw($Bin);
use lib( "$Bin/../.." );
use SBEAMS::Connection;
use SBEAMS::Connection::Tables;
my $sbeams = SBEAMS::Connection->new();

# uncomment to troubleshoot
close(STDERR);

use constant REFRESH_HANDLE => 1;

$|++; # unbuffer output
my $iter = 3;


# db handle
my $dbh = dbConnect();
print "\t$dbh->{Driver}->{Name}, version $dbh->{Driver}->{Version}\n\n";

# number of rows in test table at any point in time
my $numrows;

# message passing from test to main 
my $msg;

# DBI variable settings
my $ac = '';
my $re = '';

my $cid = $sbeams->getCurrent_contact_id();

  # Test ability to set AutoCommit ON, setup db
  ok( setAutoCommit( 1 ), 'Set Autocommit ON' );
  ok( checkCommitState( 1 ), "Verify autocommit state - ON" );
  ok( deleteRows(), "Clean up database" );


  # Test inserts with autocommit ON
  setNumrows();
  ok( testInsert(), "Insert $iter rows" );
  ok( checkNumrows( $numrows + $iter ), "Check number of rows: $msg" );

  # Test rolled-back inserts with autocommit ON
  setNumrows( );
  ok( testInsert( ), "Insert $iter rows" );
  ok( testRollback( ), 'Rollback transaction' );
  ok( checkNumrows( $numrows + $iter ), "Check number of rows: $msg" );

  # Test interrupted inserts with autocommit ON
  setNumrows();
  ok( testInsert(), "Insert $iter rows" );
  ok( testInterrupt(), 'Interrupt transaction' );
  ok( checkNumrows( $numrows + $iter ), "Check number of rows: $msg" );
  print "\n";
  print "\n";

  # Test ability to turn autocommit off
  ok( setAutoCommit(  0 ), 'Set Autocommit OFF' );
  ok( checkCommitState(  0 ), "Verify autocommit state - OFF" );
  
  # Test committed inserts with autocommit OFF
  setNumrows();
  ok( testInsert(), "Insert $iter rows" );
  ok( testCommit(), 'Commit transaction' );
  ok( checkNumrows(  $numrows + $iter ), "Check number of rows: $msg" );

  # Test rolled-back inserts with autocommit OFF
  setNumrows( );
  ok( testInsert( ), "Insert $iter rows" );
  ok( testRollback( ), 'Rollback transaction' );
  ok( checkNumrows(  $numrows ), "Check number of rows: $msg" );

  # Test interrupted inserts with autocommit OFF
  setNumrows();
  ok( testInsert(), "Insert $iter rows" );
  ok( testInterrupt(), 'Interrupt transaction' );
  ok( checkNumrows( $numrows ), "Check number of rows: $msg" );
  print "\n";
  print "\n";

  # Test transaction isolation
  ok( testInitiateTransaction(), 'Isolate transaction' );

  # Test commited inserts within transaction
  setNumrows( );
  ok( testInsert( ), "Insert $iter rows" );
  ok( testCommit(), 'Commit isolated transaction' );
  ok( checkNumrows(  $numrows + $iter ), "Check number of rows: $msg" );

  # Test rolled-back inserts within transaction
  ok( testInitiateTransaction(), 'Isolate transaction' );
  setNumrows();
  ok( testInsert( ), "Insert $iter rows" );
  ok( testRollback( ), 'Rollback transaction' );
  ok( dbping( ), 'Ping database' );
  ok( checkNumrows(  $numrows ), "Check number of rows: $msg" );

  # Test interrupted inserts within transaction
  ok( testInitiateTransaction(), 'Isolate transaction' );
  setNumrows();
  ok( testInsert(), "Insert $iter rows" );
  ok( testInterrupt(), 'Interrupt transaction' );
  ok( dbping( ), 'Ping database' );
  ok( checkNumrows( $numrows ), "Check number of rows: $msg" );

  print "\n\n";


END {
  breakdown();
} # End END

sub breakdown {
}

sub dbping {
  $dbh->ping();
}

sub testInitiateTransaction {
  $ac = $sbeams->isAutoCommit();
  $re = $sbeams->isRaiseError();

  # Set up transaction
  $sbeams->initiate_transaction();
}

sub testInterrupt {
  eval {
    undef( $dbh );
  }; 
  $sbeams->setNewDBHandle();
  $dbh = dbConnect();
  return ( defined $dbh ) ? 1 : 0;
}

sub checkCommitState {
  my $state = shift;
  return ( $dbh->{AutoCommit} == $state ) ? 1 : 0;
}

sub checkNumrows {
  my $num = shift;
  my ( $cnt ) = $dbh->selectrow_array( <<"  END" );
  SELECT COUNT(*) FROM $TB_TEST_SAMPLE
  END
  $msg = ( $num == $cnt ) ? "Found $cnt as expected" : "Found $cnt, expected $num\n";
  return ( $num == $cnt ) ? 1 : 0;
}

sub testCommit {
  eval {
  $dbh->commit();
  };
  return ( $! ) ? 0 : 1;
}

sub testBegin {
  $dbh->begin_work();
}

sub testRollback {
  eval {
    $sbeams->rollback_transaction();
    $dbh->rollback();
  };
  return 1 unless $@;
}

sub testInsert {

  my @ids;
  my $name = 'sbeams_test_data.1';

  my ( $project_id ) = $sbeams->selectrow_array( <<"  END_SQL" );
  SELECT MIN(project_id) FROM $TB_PROJECT
  END_SQL

  $project_id ||= 1;

  for ( my $i = 0; $i < $iter; $i++ ) {

    # Get a fresh handle, if so configured
    $sbeams->setNewDBHandle() if REFRESH_HANDLE;

    my $sql =<<"    END";
    INSERT INTO $TB_TEST_SAMPLE 
      ( project_id, sample_tag, age, sample_protocol_ids, 
        sample_description, modified_by_id, created_by_id ) 
        VALUES ( $project_id, '$name',
        '100', '1,2,3,4,5,6', 'autogenerated', $cid, $cid )
    END
    my $sth = $dbh->prepare( $sbeams->evalSQL( $sql ) );
    $sth->execute();

my $foo =<<'ENDIT';
    my $id = $sbeams->updateOrInsertRow( insert => 1,
                                      return_PK => 1,
                           add_audit_parameters => 1,
                                     table_name => $TB_TEST_SAMPLE,
                                    rowdata_ref => { project_id => $project_id,
                                                     sample_tag => $name,
                                                            age => $name,
                                       sample_protocol_ids => '1,2,3,4,5,6,7,8',
                                          sample_description => 'autogenerated'}
                                       );
    push @ids, $id;
ENDIT

    $name++;
  }
  return \@ids;
}

sub deleteRows {
  $dbh->do( "DELETE FROM $TB_TEST_SAMPLE" );
}


sub setNumrows {
  ( $numrows ) = $dbh->selectrow_array( <<"  END" );
  SELECT COUNT(*) FROM $TB_TEST_SAMPLE
  END
}

sub setAutoCommit {
  my $commit = shift;
  my $result = $dbh->{AutoCommit} = $commit; 
  return ( $result == $commit ) ? 1 : 0;
}
  
sub setRaiseError {
  my $raise = shift;
  my $result = $dbh->{RaiseError} = $raise; 
  return ( $result == $raise ) ? 1 : 0;
}
  


sub dbConnect {
  my $status = $sbeams->Authenticate( connect_read_only => 0 );
  return $status unless $status;
  my $dbh = $sbeams->getDBHandle();

  return $dbh;
}



__DATA__



  # Test begin with commit 
  setNumrows(  );
  ok( testBegin( ), 'Set transaction beginning' );
  ok( testInsert(  ), "Insert $iter rows" );
  ok( testCommit( ), 'Commit transaction' );
  ok( checkNumrows( $numrows + $iter ), "Check number of rows: $msg" );

  # Test begin with rollback 
  setNumrows(  );
  ok( testBegin(  ), 'Set transaction beginning' );
  ok( testInsert(  ), "Insert $iter rows" );
  ok( testRollback( ), 'Rollback transaction' );
  ok( checkNumrows(  $numrows ), "Check number of rows: $msg" );

  # Test begin with interrupt 
  setNumrows(  );
  ok( testBegin( ), 'Set transaction beginning' );
  ok( testInsert( ), "Insert $iter rows" );
  ok( testInterrupt(  ), 'Rollback transaction' );
  ok( checkNumrows(  $numrows ), "Check number of rows: $msg" );
+++++++++++++++++++++++++++++++++
  my $ac = $sbeams->isAutoCommit();
  my $re = $sbeams->isRaiseError();

  # Set up transaction
  $sbeams->initiate_transaction();

  eval {
  # insert treatment record
    my $treatment_id = $biomarker->insert_treatment( data_ref => $treat );
  # insert new samples
    my $status = $biosample->insert_biosamples(    bio_group => $treat->{treatment_name},
                                                treatment_id => $treatment_id,
                                                    data_ref => $cache->{children} );
  };   # End eval block

  my $status;
  if ( $@ ) {
    print STDERR "$@\n";
    $sbeams->rollback_transaction();
    $status = "Error: Unable to create treatment/samples";
  } else { 

    # want to calculate the number of new samples created.  $cache->{children}
    # is a hash keyed by parent_biosample_id and a arrayref of individual kids
    # as a value.  
    my $cnt = scalar( keys( %{$cache->{children}} ) );
    for my $child ( keys(  %{$cache->{children}} ) ) {
      my $reps = scalar( @{$cache->{children}->{$child}} );
      $cnt = $cnt * $reps;
      last;  # Just need the first one
    }

    $status = "Successfully created treatment with $cnt new samples";
    $sbeams->commit_transaction();
  }# End eval catch-error block

  $sbeams->setAutoCommit( $ac );
  $sbeams->setRaiseError( $re );
