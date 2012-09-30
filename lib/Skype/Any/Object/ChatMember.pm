package Skype::Any::Object::ChatMember;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('CHATMEMBER', @_) }

for my $property (qw/is_active/) {
    no strict 'refs';
    *{$property} = sub { $_[0]->_boolean($property) };
}

1;
__END__

=head1 NAME

Skype::Any::Object::ChatMember - ChatMember object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $chatmember = $skype->chatmember($id);

=head1 METHODS

=head2 C<property>

=over 4

=item chatname

=item identity

=item role

=item is_active

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
