.PHONY: usage setup

usage:
	@echo "USAGE: make setup"

setup:
	aptitude install liburi-perl libyaml-perl libwww-perl curl

