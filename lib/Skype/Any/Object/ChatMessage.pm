package Skype::Any::Object::ChatMessage;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('CHATMESSAGE', @_) }

for my $property (qw/is_editable/) {
    no strict 'refs';
    *{$property} = sub { $_[0]->_boolean($property) };
}

sub user {
    my $self = shift;
    my $from_handle = $self->property('from_handle');
    return $self->object(user => $from_handle);
}

sub chat {
    my $self = shift;
    my $chatname = $self->property('chatname');
    return $self->object(chat => $chatname);
}

1;
__END__

=head1 NAME

Skype::Any::Object::ChatMessage - 

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $chatmessage = $skype->chatmessage($id);

=head1 METHODS

=head2 C<user>

=head2 C<chat>

=head2 C<property>

=over 4

=item timestamp

=item from_handle

=item from_dispname

=item type

=item status

=item leavereason

=item chatname

=item users

=item is_editable

=item edited_by

=item edited_timestamp

=item options

=item role

=item seen

=item body

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
