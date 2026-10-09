DIR = test
MALICIOUS_DIR = q
INTERVAL = 5

.PHONY: pre-build antivirus restore

pre-build:
	mkdir -p "$(MALICIOUS_DIR)"
antivirus: pre-build
	./antivirusd.sh "$(DIR)" "$(MALICIOUS_DIR)" "$(INTERVAL)"
restore: pre-build
	./restore.sh "$(DIR)" "$(MALICIOUS_DIR)"
