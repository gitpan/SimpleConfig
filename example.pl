#!/usr/bin/perl -w
#
# Testing SimpleConfig
#
# Last updated by gossamer on Tue Sep  1 22:43:42 EST 1998
#

use SimpleConfig;


my $config = SimpleConfig->new("./example.config", [qw(Test1 Test2)]);

$config->parse();

print "The value for directive Test1 is: " . $config->get_value("Test1") . "\n";
