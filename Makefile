SHELL = /bin/sh

REPO_URL = "https://github.com/rgomezflores/roberto_org"
BRANCH = master
LOCAL_DIR = "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org1"
SFDX_PATH = "C:/Program Files/sfdx/bin/"
STARTCOMMIT = ${StartCommit}
ENDCOMMIT = ${EndCommit}
CHECKONLY = ${CheckOnly}
TESTCLASSES = ${TestClasses}
TESTCLASSES_DEFINITION = ${TestClasses_definition}

checkout:
	@if exist $(LOCAL_DIR) rmdir /s /q $(LOCAL_DIR)
	git clone --branch $(BRANCH) $(REPO_URL) $(LOCAL_DIR)

install-sfdxcli:
	npm install sfdx-cli --globa
	@echo "Successully installed sfdx-cli"
	$(SFDX_PATH)sfdx version

check-sfdx:
	$(SFDX_PATH)sfdx update
	@echo "Successully updated sfdx-cli"
	$(SFDX_PATH)sfdx version

install-sgd-plugin:
	$(SFDX_PATH)sfdx plugins
	@echo "Successully installed sfdx-git-delta"

create-deltaPackage:
	cd $(LOCAL_DIR)
	@if exist DeltaPackage rmdir /s /q DeltaPackage
	mkdir DeltaPackage && $(SFDX_PATH)sfdx sgd:source:delta --to "$(ENDCOMMIT)" --from "$(STARTCOMMIT)" --output "./DeltaPackage" --generate-delta

ifdef $(CheckOnly)
		OUTP1 = 'You will execute a Validation with TestClasses'
else
		OUTP1 = "Error Fake2"
endif

sfdx-deliver:
	$(OUTP1)