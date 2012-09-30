package Skype::Any::API;
use strict;
use warnings;
use Carp ();
use Encode ();
use Skype::Any::Command;
use Skype::Any::Error;

sub new {
    my ($class, $c, %args) = @_;

    my $self = bless {
        %args,
        c => $c,
        commands => {},
    }, $class;

    $self->handler->register(Notify => sub {
        my $notification = shift;
        my ($obj, $id, $property, $value) = split /\s+/, $notification, 4;
        if (grep { $_ eq $obj } qw/USER CALL MESSAGE CHAT CHATMEMBER CHATMESSAGE VOICEMAIL SMS APPLICATION GROUP FILETRANSFER/) {
            my $object = $self->{c}->object($obj => $id);
            $self->handler->call($obj, _ => $object, $value);
            $self->handler->call($obj, $property => $object, $value);
        }
    });

    return $self;
}

sub handler { $_[0]->{c}->handler }

sub run;
sub attach;
sub is_running;
sub send;
sub sleep;

sub send_command {
    my ($self, $cmd, $expected) = @_;
    $expected = '' unless defined $expected;

    my $command = Skype::Any::Command->new($cmd);
    $self->_push_command($command);
    my $reply = $self->send($command->as_string);
    if ($reply) {
        if ($reply =~ /^#\Q$command->{id}\E/) {
            $self->_notify_handler()->($self, $reply);
        }
    } else {
        if ($command->{blocking}) {
            while (!$command->{reply}) {
                $self->sleep;
            }
        }
    }
    $self->handler->call('Command', _ => $command);

    my ($a, $b) = $command->split_reply(2);
    if ($a eq 'ERROR') {
        my ($code, $description) = split /\s+/, $b, 2;
        my $error = Skype::Any::Error->new($code, $description);
        $self->handler->call('Error', _ => $error);
        Carp::croak("Caught error: $error");
    }
    unless ($command->{reply} =~ /^\Q$expected\E/) {
        Carp::croak("Unexpected reply from Skype, got [$command->{reply}], expected [$expected (...)]");
    }
    return $command;
}

sub _push_command {
    my ($self, $command) = @_;
    if ($command->{id} < 0) {
        my $id = 0;
        while (exists $self->{commands}{$id}) {
            $id++;
        }
        $command->{id} = $id;
    } elsif (exists $self->{commands}{$command->{id}}) {
        Carp::croak('Command id conflict');
    }
    $self->{commands}{$command->{id}} = $command;
}

sub _pop_command {
    my ($self, $id) = @_;
    return delete $self->{commands}{$id};
}

sub _notify_handler {
    my $self = shift;
    return sub {
        my ($notification) = @_;
        if ($notification =~ s/^#//) {
            my ($id, $reply) = split /\s+/, $notification, 2;
            my $command = $self->_pop_command($id);
            if ($command) {
                $reply = Encode::decode_utf8($reply);
                $command->{reply} = $reply;
                $self->handler->call('Reply', _ => $command);
            } else {
                $self->handler->call('Notify', _ => $reply);
            }
        } else {
            $self->handler->call('Notify', _ => $notification);
        }
    };
}

1;
__END__

=head1 NAME

Skype::Any::API - API interface for Skype::Any

=head1 METHODS

=head2 C<run>

  $api->run();

=head2 C<is_running>

  $api->is_running();

=head2 C<send_command>

  $api->send_command($cmd, $expected);

=head1 ATTRIBUTES

=head2 C<c>

=head2 C<handler>

=cut
