package Skype::Any::API::darwin;
use strict;
use warnings;
use parent qw/Skype::Any::API/;
use Cocoa::Skype;
use Cocoa::EventLoop;

sub new {
    my ($class, $c, %args) = @_;

    my $self = $class->SUPER::new($c, %args);
    my $protocol = $args{protocol} || 8;
    my $client = Cocoa::Skype->new(
        name => $self->{name},
        on_attach_response => sub {
            my $code = shift;
            if ($code == 1) { # on success
                $self->send(sprintf 'PROTOCOL %d', $protocol);
            }
        },
        on_notification_received => $self->_notify_handler(),
    );
    $self->{client} = $client;

    return $self;
}

sub run        { Cocoa::EventLoop->run }
sub is_running { $_[0]->{client}->isRunning }
sub attach     { $_[0]->{client}->connect }
sub send       { shift->{client}->send(@_) }

sub sleep {
    Cocoa::EventLoop->run_while(0.01);
}

1;
