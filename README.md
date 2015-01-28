prowlでIPアドレスを通知する

# セットアップ

	$ sudo su
	# cd /opt
	# git clone https://github.com/mamemomonga/prowl_iface_ip
	# cd prowl_iface_ip
	# make setup
	# mv config.yaml.example config.yaml
	# vim config.yaml
	# IFACE='eth0' ./prowl_iface_ip.pl

# ネットワークデバイスUP時に実行する

* wpa\_roamで設定したWiFiデバイスの例です。
* 「任意の名前」は wpa\_supplicant.conf で設定した id\_str= の値
* prowl\_iface\_ip.plの引数には好きな文字列を設定できます。省略も可。

/etc/network/interface を編集する。

	# vim /etc/network/interfaces
	auto wlan0
	iface wlan0 inet manual
	   wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

	iface 任意の名前 inet dhcp
	   up /opt/prowl_iface_ip/prowl_iface_ip.pl 任意の名前

ネットワークの再接続

	# /etc/init.d/networking stop
	# /etc/init.d/networking start

これで通知がくれば成功です。
