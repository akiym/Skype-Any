package Skype::Any::Object::Group;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('GROUP', @_) }

1;
__END__

=head1 NAME

Skype::Any::Object::Group - Group object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $group = $skype->group($id);

=head1 METHODS

=head2 C<property>

=over 4

=item type

=item custom_group_id

=item displayname

=item nrofusers

=item nrofusers_online

=item users

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
