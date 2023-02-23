
REPO_URL = "https://github.com/rgomezflores/roberto_org"
BRANCH = master
LOCAL_DIR = "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org"
STARTCOMMIT = ${StartCommit}
ENDCOMMIT = ${EndCommit}
CHECKONLY = ${CheckOnly}
TESTCLASSES = ${TestClasses}
TESTCLASSES_DEFINITION = ${TestClasses_definition}

checkout:
	git clone --branch $(BRANCH) $(REPO_URL) $(LOCAL_DIR)

install-sfdxcli:
    @echo 'y' | npm install sfdx-cli --global
    @echo "Successully installed sfdx-cli"
    sfdx version

check-sfdx:
	sfdx update
    @echo "Successully updated sfdx-cli"
	sfdx version

install-sgd-plugin:
	@echo 'y' | sfdx plugins:install sfdx-git-delta@latest-rc
	@echo "Successully installed sfdx-git-delta"
    sdfx plugins

create-deltaPackage:
    $(STARTCOMMIT)
	$(ENDCOMMIT)
	cd $(LOCAL_DIR) && mkdir DeltaPackage && ls -lha && sfdx sgd:source:delta --to "$(EndCommit)" --from "$(StartCommit)" --output "./DeltaPackage" --generate-delta

deploy:
	$(CHECKONLY)
	$(TESTCLASSES)
	$(TESTCLASSES_DEFINITION)
	cd $(LOCAL_DIR); ls -alh; \

    ifeq ($(CheckOnly)$(TestClasses),TRUETRUE)
    do echo 'You will execute a Validation with TestClasses'	
    sfdx force:source:deploy \
    --checkonly \
    --sourcepath=$(LOCAL_DIR)/DeltaPackage \
    --targetusername rgomezflores@deloitte.com \
	--testlevel RunSpecifiedTests \
	--runtests ${TESTCLASSES_DEFINITION} \
	--wait 50 --verbose
    endif
                        