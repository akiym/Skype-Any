package Skype::Any::Command;
use strict;
use warnings;
use overload q{""} => \&as_string, fallback => 1;
use Encode ();

sub new {
    my ($class, $command, $args) = @_;
    $args ||= {};

    return bless {
        command  => $command,
        id       => -1,
        blocking => 1,
        reply    => '',
        %$args,
    }, $class;
}

sub reply { $_[0]->{reply} }

sub as_string {
    my $self = shift;
    my $cmd = sprintf '#%d %s', $self->{id}, $self->{command};
    return Encode::encode_utf8($cmd);
}

sub split_reply {
    my ($self, $limit) = @_;
    $limit ||= 4;

    return split /\s+/, $self->{reply}, $limit;
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

=cut
