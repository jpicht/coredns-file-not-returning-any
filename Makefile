test:
	@echo "-------------------- startup       --------------------"
	$(DOCKER) run -d --name coredns-test-server -p 10053:53 -v $$PWD/zones:/zones:ro -v $$PWD/config/Corefile:/Corefile:ro docker.io/coredns/coredns -conf /Corefile
	@echo "-------------------- query for A   --------------------"
	dig @localhost -p 10053 +tcp +short host.testcase.lan A
	@echo "-------------------- query for ANY --------------------"
	dig @localhost -p 10053 +tcp +short host.testcase.lan ANY
	@echo "-------------------- logs          --------------------"
	$(DOCKER) logs coredns-test-server
	@echo "-------------------- shutdown      --------------------"
	$(DOCKER) stop coredns-test-server
	$(DOCKER) rm coredns-test-server

test-bind:
	@echo "-------------------- startup       --------------------"
	$(DOCKER) run -d --name bind9-test-server -p 10053:53 -v $$PWD/config/named.conf.local:/etc/bind/named.conf.local -v $$PWD/zones:/zones docker.io/sameersbn/bind:9.11.3-20190706
	sleep 3
	@echo "-------------------- query for A   --------------------"
	dig @localhost -p 10053 +tcp +short host.testcase.lan A
	@echo "-------------------- query for ANY --------------------"
	dig @localhost -p 10053 +tcp +short host.testcase.lan ANY
	@echo "-------------------- shutdown      --------------------"
	$(DOCKER) stop bind9-test-server
	$(DOCKER) rm bind9-test-server

