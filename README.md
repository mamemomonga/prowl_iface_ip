prowl$B$G(BIP$B%"%I%l%9$rDLCN$9$k(B

# $B%;%C%H%"%C%W(B

	$ sudo su
	# cd /opt
	# git clone https://github.com/mamemomonga/prowl_iface_ip
	# cd prowl_iface_ip
	# make
	# mv config.yaml.example config.yaml
	# vim config.yaml
	# IFACE='eth0' ./prowl_iface_ip.pl

# $B%M%C%H%o!<%/%G%P%$%9(BUP$B;~$K<B9T$9$k(B

* wpa\_roam$B$G@_Dj$7$?(BWiFi$B%G%P%$%9$NNc$G$9!#(B
* $B!VG$0U$NL>A0!W$O(B wpa\_supplicant.conf $B$G@_Dj$7$?(B id_str= $B$NCM(B
* prowl\_notify\_ipaddr.pl$B$N0z?t$K$O9%$-$JJ8;zNs$r@_Dj$G$-$^$9!#>JN,$b2D!#(B

/etc/network/interface $B$rJT=8$9$k!#(B

	# vim /etc/network/interfaces
	auto wlan0
	iface wlan0 inet manual
	   wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

	iface $BG$0U$NL>A0(B inet dhcp
	   up /root/sbin/prowl_notify_ipaddr.pl $BG$0U$NL>A0(B

$B%M%C%H%o!<%/$N:F@\B3(B

	# /etc/init.d/networking stop
	# /etc/init.d/networking start

$B$3$l$GDLCN$,$/$l$P@.8y$G$9!#(B
