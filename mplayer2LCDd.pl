#!/usr/bin/perl

$|++;

use IO::Socket;

my $socket = IO::Socket::INET->new(PeerAddr => "127.0.0.1",
                                PeerPort => 13666,
                                Proto    => "tcp",
                                Type     => SOCK_STREAM)
  or die "Couldn't connect to $remote_host:$remote_port : $@\n";

# Hello:
print $socket "hello\n";
my $hello = <$socket>;

# Add screen:
print $socket "screen_add s1\n";
my $screen_add = <$socket>;

# Set screen priority:
print $socket "screen_set s1 -priority 128\n";
my $screen_set = <$socket>;

# Add text:
print $socket "widget_add s1 w1 title\n";
my $text1 = <$socket>;

# Add text2:
print $socket "widget_add s1 w2 string\n";
my $text2 = <$socket>;

while (1)
{
  my $data = <STDIN>;

  if (my ($name) = $data =~ /Name\s+:\s+([A-Za-z0-9\+\s\-]+)/g)
  {
#print $name . "\n";
    $name =~ s/\+/ /g;
    $name =~ s/\n//g;
    print $socket "widget_set s1 w1 {$name}\n";
    my $rname = <$socket>;
  }
  elsif (my ($title) = $data =~ /ICY Info: StreamTitle='([A-Z-z0-9\+\s\-]+)';/g)
  {
    $title =~ s/\+/ /g;
    $title =~ s/\n//g;
#print $title . "\n";
    print $socket "widget_set s1 w2 1 2 {$title}\n";
    my $rtitle = <$socket>;
  }
}

# Add text2:
print $socket "screen_del s1\n";
my $sdel = <$socket>;

close($socket);

