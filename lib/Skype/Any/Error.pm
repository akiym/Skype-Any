package Skype::Any::Error;
use strict;
use warnings;
use overload '0+' => \&as_numeric, q{""} => \&as_string, fallback => 1;

sub new {
    my ($class, $code, $description) = @_;
    return bless {
        code        => $code,
        description => $description,
    }, $class;
}

sub as_numeric { $_[0]->{code} }
sub as_string  { $_[0]->{description} }

1;
