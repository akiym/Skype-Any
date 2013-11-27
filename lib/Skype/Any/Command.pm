package Skype::Any::Command;
use strict;
use warnings;
use Carp ();
use AnyEvent;
use Skype::Any::Error;

sub new {
    my ($class, $command) = @_;

    my $cv = AE::cv();
    $cv->cb(sub { $_[0]->recv });

    return bless {
        cv      => $cv,
        command => $command,
        id      => 0,
        reply   => undef,
    }, $class;
}

sub with_id {
    my $self = shift;
    return sprintf '#%d-%d %s', $self->{id}, $$, $self->{command};
}

sub retrieve_reply {
    my $self = shift;
    return $self->{reply} ||= $self->{cv}->recv;
}

sub reply {
    my ($self, $expected) = @_;

    my $reply = $self->retrieve_reply();
    my ($obj, $params) = split /\s+/, $reply, 2;
    if ($obj eq 'ERROR') {
        my ($code, $description) = split /\s+/, $params, 2;
        my $error = Skype::Any::Error->new($code, $description);
        $self->handler->call('Error', _ => $error);
        Carp::carp("Caught error: $error");
        return undef;
    }

    if ($expected && $reply !~ /^\Q$expected\E/) {
        Carp::croak("Unexpected reply from Skype, got [$reply], expected [$expected (...)]");
    }

    return $reply;
}

sub split_reply {
    my ($self, $limit) = @_;
    $limit ||= 4;

    my $reply = $self->reply();
    return split /\s+/, $reply, $limit;
}

1;
__END__

=head1 NAME

Skype::Any::Command - Command interface for Skype::Any

=head1 METHODS

=head2 C<as_string>

  $command->as_string();

Return a command as binary string.

=head2 C<split_reply>

  $command->split_reply($limit);

Return a list of command which is split. $limit is by default 4. It means that command splits to obj, id, property, value.

=head1 ATTRIBUTES

=head2 C<reply>

Reply command sent.

=cut
