package Skype::Any::API::linux;
use strict;
use warnings;
use parent qw/Skype::Any::API/;
use AnyEvent;
use AnyEvent::DBus;
use Net::DBus::Skype::API;

sub new {
    my ($class, $c, %args) = @_;

    my $self = $class->SUPER::new($c, %args);
    my $protocol = $args{protocol} || 8;
    my $client = Net::DBus::Skype::API->new(
        name     => $args{name},
        protocol => $protocol,
        notify   => $self->_notify_handler(),
    );
    $self->{client} = $client;

    return $self;
}

sub run        { AE::cv()->recv }
sub is_running { $_[0]->{client}->is_running }
sub attach     { $_[0]->{client}->attach }
sub send       { shift->{client}->send_command(@_) }

sub sleep {
    my $cv = AE::cv();
    my $t; $t = AE::timer 0, 0.01, sub {
        undef $t;
        $cv->send;
    };
    $cv->recv;
}

1;
