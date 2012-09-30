package Skype::Any::Object;
use strict;
use warnings;

sub new {
    my ($class, $c, $args) = @_;
    return bless {
        c => $c,
        %$args,
    }, $class;
}

sub api     { $_[0]->{c}->api }
sub handler { $_[0]->{c}->handler }

sub object { shift->{c}->object(@_) }

sub property;
sub alter;

sub _property {
    my ($self, $name, $property, $value) = @_;
    $property = uc $property;
    my $cmd = sprintf '%s %s %s', $name, $self->{id}, $property;
    if (!defined $value) {
        my $command = $self->api->send_command(sprintf('GET %s', $cmd), $cmd);
        my @reply = $command->split_reply;
        return $reply[3];
    } else {
        $self->api->send_command(sprintf('SET %s %s', $cmd, $value), $cmd);
    }
}

sub _alter {
    my ($self, $name, $alter, $args) = @_;
    my $cmd = sprintf 'ALTER %s %s %s', $name, $self->{id}, $alter;
    if (defined $args) {
        $cmd = sprintf '%s %s', $cmd, $args;
    }
    $self->api->send_command($cmd);
}

sub _boolean {
    my ($self, $property) = @_;
    return $self->property($property) eq 'TRUE';
}

sub AUTOLOAD {
    my $property = our $AUTOLOAD;
    $property =~ s/.*:://;
    {
        no strict 'refs';
        *{$property} = sub {
            my $self = shift;
            $self->property($property, @_);
        };
    }
    goto &$property;
}

sub DESTROY {}

1;
__END__

=head1 NAME

Skype::Any::Object - 

=head1 METHODS

=head2 C<object>

  $object->object($obj, @args);

Create instance of Skype::Any::Object*.

  my $user = $object->object(user => 'echo123');

=head2 C<property>

  $object->property($property);

Get $property.

  $object->property($property, $value);

Set $property to $value.

=head1 ATTRIBUTES

=head2 C<api>

L<Skype::Any::API>

=head2 C<handler>

L<Skype::Any::Handler>

=cut
