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

sfdx-deliver:
ifeq ($(CheckOnly)$(TestClasses),truetrue)
	@echo "You will execute a Validation with TestClasses" \
	$(SFDX_PATH)sfdx force:source:deploy \
	--checkonly \
	--sourcepath=$(LOCAL_DIR)/DeltaPackage \
	--targetusername rgomezflores@deloitte.com \
	--testlevel RunSpecifiedTests \
	--runtests ${TESTCLASSES_DEFINITION} \
	--wait 50 --verbose
else
ifeq ($(CheckOnly)$(TestClasses),truefalse)
	@echo "You will execute a Validation without TestClasses" \
	$(SFDX_PATH)sfdx force:source:deploy \
	--checkonly \
	--sourcepath=$(LOCAL_DIR)/DeltaPackage \
	--targetusername rgomezflores@deloitte.com \
	--wait 50 --verbose
else
ifeq ($(CheckOnly)$(TestClasses),falsetrue)
	@echo "You will execute a Deployment with TestClasses" \
	$(SFDX_PATH)sfdx force:source:deploy \
	--sourcepath=$(LOCAL_DIR)/DeltaPackage \
	--targetusername rgomezflores@deloitte.com \
	--testlevel RunSpecifiedTests \
	--runtests ${TESTCLASSES_DEFINITION} \
	--wait 50 --verbose
	else
ifeq ($(CheckOnly)$(TestClasses),falsefalse)
	@echo "You will execute a Deployment without TestClasses" \
	$(SFDX_PATH)sfdx force:source:deploy \
	--sourcepath=$(LOCAL_DIR)/DeltaPackage \
	--targetusername rgomezflores@deloitte.com \
	--wait 50 --verbose
	else
	Error Deployment Process!!
endif
endif
endif	
endif