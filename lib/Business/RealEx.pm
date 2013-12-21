package Business::RealEx;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Digest::SHA1 'sha1_hex';
use LWP::UserAgent;
use Carp 'croak';
use XML::Simple;

sub new {
    my $class = shift;

    my %args = @_ % 2 ? %{$_[0]} : (@_);

    $args{merchantid} or croak 'merchantid is required.';
    $args{secret} or croak 'secret is required.';
    $args{ua} ||= LWP::UserAgent->new;

    bless \%args, $class;
}

sub new_payer {
    my $self = shift;
    my %args = @_ % 2 ? %{$_[0]} : (@_);

    $args{orderid} or croak 'orderid is required.';
    $args{payer_ref} or croak 'ref is required.';
    $args{first_name} or croak 'first_name is required.';
    $args{surname} or croak 'surname is required.';
    $args{company} or croak 'company is required.';

    $args{payer_type} ||= 'Business';
    $args{payer_title} ||= 'Mr';
    $self->{__timestamp} = __timestamp();
    my $sha1hash = $self->__sha1hash($args{orderid}, $args{amount} || '', $args{currency} || '', $args{payer_ref});

    # we omit other fields for now
    my $xml = <<XML;
<request type="payer-new" timestamp="$self->{__timestamp}">
<merchantid>$self->{merchantid}</merchantid>
<orderid>$args{orderid}</orderid>
<payer type="$args{payer_type}" ref="$args{payer_ref}">
<title>$args{payer_title}</title>
<firstname>$args{first_name}</firstname>
<surname>$args{surname}</surname>
<company>$args{company}</company>
</payer>
<sha1hash>$sha1hash</sha1hash>
</request>
XML

    return $self->__request($xml);
}

sub __request {
    my ($self, $xml) = @_;

    my $resp = $self->{ua}->post('https://epage.payandshop.com/epage-remote-plugins.cgi', Content => $xml);
    use Data::Dumper; print Dumper(\$resp);
    return { error => 'Failed to talk with remote server: ' . $resp->status_line } unless $resp->is_success;
    return XMLin($resp->content, ForceArray => 0, SuppressEmpty => '');
}

sub __sha1hash {
    my $self = shift;
    return sha1_hex(join('.', sha1_hex($self->__sha_string(@_)), $self->{secret}));
}

sub __sha_string {
    my ($self, $orderid, $amount, $currency, $payerref) = @_;
    return join('.', $self->{__timestamp}, $self->{merchantid}, $orderid, $amount, $currency, $payerref);
}

sub __timestamp {
    my @d = localtime();
    return sprintf('%04d%02d%02d%02d%02d%02d', $d[5] + 1900, $d[4] + 1, $d[3], @d[qw/2 1 0/]);
}

1;
__END__

=encoding utf-8

=head1 NAME

Business::RealEx - Blah blah blah

=head1 SYNOPSIS

  use Business::RealEx;

=head1 DESCRIPTION

Business::RealEx is

=head1 AUTHOR

Fayland Lam E<lt>fayland@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2013- Fayland Lam

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
