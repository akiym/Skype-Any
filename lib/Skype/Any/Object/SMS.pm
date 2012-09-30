package Skype::Any::Object::SMS;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('SMS', @_) }
sub alter    { shift->_alter('SMS', @_) }

for my $property (qw/is_failed_unseen/) {
    no strict 'refs';
    *{$property} = sub { $_[0]->_boolean($property) };
}

1;
__END__

=head1 NAME

Skype::Any::Object::SMS - SMS object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $sms = $skype->sms($id);

=head1 METHODS

=head2 C<property>

=over 4

=item body

=item type

=item status

=item failurereason

=item is_failed_unseen

=item timestamp

=item price

=item price_precision

=item price_currency

=item reply_to_number

=item target_numbers

=item target_statuses

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
