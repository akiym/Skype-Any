package Skype::Any::Util;
use strict;
use warnings;
use parent qw/Exporter/;

our @EXPORT_OK = qw/load_class/;

my %loaded;
sub load_class {
    my ($class, $prefix) = @_;

    if ($prefix) {
        unless ($class =~ s/^\+// || $class =~ /^$prefix/) {
            $class = "$prefix\::$class";
        }
    }

    return $class if $loaded{$class}++;

    my $file = $class;
    $file =~ s!::!/!g;
    require "$file.pm"; ## no critic

    return $class;
}

1;
