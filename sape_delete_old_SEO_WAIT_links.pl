#!/usr/bin/env perl

use strict;
use utf8;

use RPC::XML::Client;
use Data::Dumper;
use Date::Parse;

# определяем текущую директорию
$0 =~ /^.*[\/\\]/;
# читаем конфиг
my $config = do $& . '/config.pl';

die 'No config. Copy file config.pl.sample to config.pl and edit it!' if ref $config ne 'HASH';

# в Sape.ru нужно сохранить присланные куки после авторизации - поэтому передаём
# при создании клиента соответсвующие опции
my $client = new RPC::XML::Client('http://api.sape.ru/xmlrpc/', useragent => [cookie_jar => {}]);

sub sape_request {
    my $request = RPC::XML::request->new(@_);
    my $res = $client->send_request($request);

    if (ref $res eq 'HASH' and $res->{faultCode}) {
        die( $res->{faultCode}->value . ' ::: ' . $res->{faultString}->value );
    }

    return $res->value;
}

# авторизация на сервере
my $user_id = sape_request 'sape.login', $config->{login}, $config->{password}, $config->{is_md5_hash};

#my $user_info = sape_request 'sape.get_user';

my $sites = sape_request 'sape.get_sites';

my $now = time;

foreach my $site (@$sites) {
    #print $site->{id};
    my $links = sape_request 'sape.get_site_links', $site->{id}, {status => 'WAIT_SEO'};

    #print Dumper($links);
    foreach my $link (@$links) {
        my $placed = str2time $link->{date_placed};
        print $link->{url}, ' placed ', ($now - $placed) / 3600 / 24, ' days', "\n";

        do {
            print "DELETE\n";
            sape_request 'sape.placement_delete', new RPC::XML::string($link->{id});
        } if ($now - $placed) > $config->{max_SEO_WAIT_time};
    }
}

print "ok\n";
