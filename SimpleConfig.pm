package SimpleConfig;
#
# Simple interface to a configuration file
#
# ObLegalStuff:
#    Copyright (c) 1998 Bek Oberin. All rights reserved. This program is
#    free software; you can redistribute it and/or modify it under the
#    same terms as Perl itself.
# 
# Last updated by gossamer on Wed Sep  2 13:58:08 EST 1998
#

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw();

$VERSION = "0.2";

my $DEBUG = 1;

=head1 NAME

SimpleConfig - Simple configuration file parser

=head1 SYNOPSIS

   use SimpleConfig;

   $config = SimpleConfig->new("configrc", [qw(Foo Bar Baz Quux)]);

   $config->parse();

=head1 DESCRIPTION

   C<SimpleConfig> reads and parses simple configuration files.  It's
   designed to be smaller and simpler than the C<ConfigReader> module
   and is more suited to simple configuration files.

=cut

###################################################################
# Functions under here are member functions                       #
###################################################################

=head1 CONSTRUCTOR

=item new ( FILENAME, DIRECTIVES )

This is the constructor for a new SimpleConfig object.

C<FILENAME> tells the instance where to look for the configuration
file.

C<DIRECTIVES> is a reference to an array.  Each member of the array
should contain one valid directive.

=cut

sub new {
   my $prototype = shift;
   my $filename = shift;
   my $keyref = shift;

   my $class = ref($prototype) || $prototype;
   my $self  = {};

   $self->{"filename"} = $filename;
   $self->{"validkeys"} = $keyref;

   bless($self, $class);
   return $self;
}


#
# destructor
#
sub DESTROY {
   my $self = shift;

   return 1;
}

=pod
=item parse ()

This does the actual work.  No parameters needed.

=cut

sub parse {
   my $self = shift;

   open(CONFIG, $self->{"filename"}) || 
      die "Config: Can't open config file " . $self->{"filename"} . ": $!";

   while (<CONFIG>) {
      chomp;

      next if /^\s*$/;  # blank
      next if /^\s*#/;  # comment

      my ($key, $value) = &parse_line($_);
      print STDERR "Key:  '$key'   Value:  '$value'\n" if $DEBUG;
      if (&is_arraymember($key, $self->{"validkeys"})) {
         $self->{"config_data"}{$key} = $value;
      } else {
         die "Config:  Invalid key '$key'\n";
      }
   }

   close(CONFIG);
   return 1;

}

=pod
=item get_value ( DIRECTIVE )

Returns the parsed value for that directive.

=cut

sub get_value {
   my $self = shift;
   my $key = shift;

   return $self->{"config_data"}{$key};
}

sub parse_line {
   my $text = shift;

   my ($key, $value);

   if ($text =~ /^\s*(\w+)\s+(.*)?\s*$/) {
      $key = $1;
      $value = $2;
   } else {
      die "Config: Can't parse line: $text\n";
   }

   return ($key, $value);
}

sub is_arraymember {
   my $value = shift;
   my $arrayref = shift;

   foreach (@$arrayref) {
      return 1 if $_ eq $value;
   }
   return 0;
}

=pod

=head1 LIMITATIONS/BUGS

Directives are case-sensitive.

If a directive is repeated, the first instance will silently be
ignored.

Always die()s on errors instead of reporting them.

C<get_value()> doesn't warn if used before C<parse()>.

C<get_value()> doesn't warn if you try to acces the value of an
unknown directive not know (ie: one that wasn't passed via C<new()>).

All these will be addressed in future releases.

=head1 AUTHOR

Bek Oberin <gossamer@tertius.net.au>

=head1 COPYRIGHT

Copyright (c) 1998 Bek Oberin.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#
# End code.
#
1;
