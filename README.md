# NAME

Business::RealEx - RealVault, Remote (Integrated) XML Solution

# SYNOPSIS

    use Business::RealEx;

    my $realex = Business::RealEx->new(
        merchantid => 'zzz',
        secret => 'blabla',
    );

    my $data = $realex->new_payer(
        orderid => abs($$) . "-" . time() . "-robin",
        payerref => 'fayland',
        firstname => 'Fayland',
        surname => 'Lam',
        company => '247moneybox'
    );
    print Dumper(\$data);

    my $data = $realex->new_card(
        orderid => abs($$) . "-" . time() . "-robin",
        ref => 'fayland-card',
        payerref => 'fayland',
        number => '4988433008499991',
        expdate => '0115',
        chname => 'Fayland Lam',
        type => 'visa',
    );
    print Dumper(\$data);

    my $data = $realex->update_card(
        orderid => abs($$) . "-" . time() . "-robin",
        ref => 'fayland-card',
        payerref => 'fayland',
        expdate => '0115',
        chname => 'Fayland Lam',
        type => 'visa',
    );
    print Dumper(\$data);

    my $data = $realex->delete_card(
        ref => 'fayland-card',
        payerref => 'fayland',
    );
    print Dumper(\$data);

    my $data = $realex->receipt_in(
        orderid => abs($$) . "-" . time() . "-robin",
        account => 'internet',
        amount => '19999',
        currency => 'EUR',
        payerref => 'fayland',
        paymentmethod => 'visa01', # card-ref?
    );
    print Dumper(\$data);

# DESCRIPTION

Business::RealEx is for [https://resourcecentre.realexpayments.com/documents/pdf.html?id=152](https://resourcecentre.realexpayments.com/documents/pdf.html?id=152)

# AUTHOR

Fayland Lam <fayland@gmail.com>

# COPYRIGHT

Copyright 2013- Fayland Lam

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
