package Skype::Any::Object::FileTransfer;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->SUPER::property('FILETRANSFER', @_) }
sub alter    { shift->SUPER::alter('FILETRANSFER', @_) }

1;
__END__

=head1 NAME

Skype::Any::Object::FileTransfer - FileTransfer object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $filetransfer = $skype->filetransfer($id);

=head1 METHODS

=head2 C<property>

=over 4

=item type

=item status

=item failusereason

=item partner_handle

=item partner_dispname

=item starttime

=item finishtime

=item filepath

=item filesize

=item bytespersecond

=item bytestransferred

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
