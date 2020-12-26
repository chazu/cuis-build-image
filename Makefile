CUIS_IMAGE=Cuis5.0-4426.image
DESTINATION_IMAGE=smoltalk.image

.PHONY: setup
setup: ## Add cuis as submodule and init/update it
	-git submodule add https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-Dev.git
	git submodule update --init --recursive
	./Cuis-Smalltalk-Dev/pullAllRepos.sh

.PHONY: clone_cogspur
clone_cogspur: ## Clone Cogspur VM into repository
	wget -O cogspur.tgz https://github.com/OpenSmalltalk/opensmalltalk-vm/releases/download/201901172323/squeak.cog.spur_linux64x64_201901172323.tar.gz
	mkdir cogspur-temp
	mv cogspur.tgz cogspur-temp/cogspur.tgz
	cd cogspur-temp && tar -zxvf cogspur.tgz
	mv ./cogspur-temp/sqcogspur64linuxht ./cogspur/
	rm -rf cogspur-temp

.PHONY: build_image
build_image: ## Run build script
	cp Cuis-Smalltalk-Dev/${CUIS_IMAGE} ./${DESTINATION_IMAGE}
	./cogspur/squeak -vm-display-null ./${DESTINATION_IMAGE} -r Cuis-Smalltalk-Dev/Packages/Features/WebClient.pck.st \
	        -d"" \
		-d"Transcript clearAll."
		-d"Smalltalk snapshot: true andQuit: true."


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

