#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use feature 'say';
use URI::Escape;
use LWP::UserAgent;
use YAML;
use FindBin;
binmode(STDIN,':utf8');
binmode(STDOUT,':utf8');
binmode(STDERR,':utf8');

my $comment=($ARGV[0] || '');
my $device=$ENV{IFACE};
my $hostname=`hostname`; chomp $hostname;

die 'IFACE undefined' unless $device;

my $config=YAML::LoadFile("$FindBin::Bin/config.yaml");

my %cnf=(
	name        => $config->{appname},
	apikey      => $config->{prowl}->{apikey},
	application => $hostname,
	event       => $device.'がUPしました',
	dev         => $device,
);

if(my $kid=fork) {
	say "$cnf{name} start PID:$kid";

} else {
    open(STDIN, '<','/dev/null') || die $!;
    open(STDOUT,'| logger -t '.$cnf{name}) || die $!;
    open(STDERR,'| logger -t '.$cnf{name}) || die $!;

	say "START $cnf{name}";

	# 時計が合う(2015/1/1 00:00:00以降になるのを待つ
	my $timeout_count=0;
	while(1) {
		last if( time > 1420038000 );
		$timeout_count++;
		die "timeout" if($timeout_count >= $config->{clock_timeout});
		sleep(1);
	}

	# IPアドレス取得
	my $ipaddr;
	if(`ip addr show $cnf{dev}` =~/inet ([0-9.\/]+) brd/m) { $ipaddr=$1 }
	exit unless $ipaddr;

	# prowl通知
	$cnf{event}.="($comment)" if $comment;
	$cnf{description}="ADDR: $ipaddr";

	if($config->{debug}) {
		while(my($key,$val)=each %cnf) {
			next if $key eq 'apikey';
			print 'prowl: '.uc($key).": $val\n";
		}
	}

	# 必須: apikey, application, event, description, curl
	my @queries;
	foreach(qw(apikey application event description priority url providerkey)) {
		push @queries,"$_=".uri_escape_utf8($cnf{$_}) if $cnf{$_};
	}

	my $ua=LWP::UserAgent->new();
	my $resp=$ua->get('https://prowlapp.com/publicapi/add?'.join('&',@queries));
	say "status: ".$resp->status_line if $config->{debug};
	say "content: ".$resp->content if $config->{debug};
}
