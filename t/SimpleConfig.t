#!perl  

use Test::More tests => 12;
 
use_ok('SimpleConfig');
use   SimpleConfig;
 
my %CONF_VALID = (PORT => '^\d+$', DB_NAME => '^\w+$', DB_DRIVER => '^SQLite|mysql|Pg$');

my %CONF_KEYS = (PORT => ' enter any number  and press Enter ');

  
  my $cfg = "./t/data/test.conf";
  my $conf =  undef;
 # 2 
  eval {
     $conf = new SimpleConfig({file  => $cfg }) 
  };
  ok( $conf , "SimpleConfig create object");
  $@ = undef;

 # 3 
 my $hashref1 =  $conf->parse; 
 ok($hashref1  , " SimpleConfig parse file  " );
   
 
   
 
#  4 
  my $hashref3 =  $conf->getNormalizedData;
  ok( $hashref3 , "SimpleConfig  getNormalizedData OK " );
 
# 5
   
  ok($hashref3->{PORT} == 8080, "  Check for key=value failed ");  
   
 # 6
   
  ok($hashref3->{METADATA_DB_FILE} eq '/home/user/somefilel', "  Check for scalar interpolation failed ");  

# 7
   
  ok($hashref3->{SQL_DB_PATH} eq '/home/user', "  Check for XML   interpolation failed " );  

# 8
   
  ok($hashref3->{SQL_production} == 1, "  Check for XML fragment attribute failed ");  

# 9
   
  ok($hashref3->{SQL_DB_DRIVER} eq 'mysql', "  Check for XML fragment  element failed ");  

# 10
  eval {  
    $conf->store("/tmp/test.conf");
     
  };
  ok(!$@, "SimpleConfig store file ". $@);  
  $@ = undef;
 
 
  # 11
  eval {    
   $conf = new SimpleConfig({file => $cfg,  dialog => undef ,  validkeys => \%CONF_VALID, prompts => \%CONF_KEYS}); 
   };
    ok(!$@ && $conf , "SimpleConfig create object with patterns and prompts");
   $@ = undef;
 # 12
    
  ok( $conf->parse , "SimpleConfig parse with prompts file   " );
  

 

print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
