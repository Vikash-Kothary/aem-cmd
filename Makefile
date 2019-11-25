all: dist

clean:
	rm -rf dist build aem_cmd.egg-info test_reports .coverage
	rm -f *.log
	find . | grep \.pyc$ | xargs rm -rf

dist: clean
	python setup.py bdist_wheel --universal

test_release: dist
	twine upload -r pypitest dist/*

release: dist
	twine upload -r pypi dist/*

test2:
	nosetests-2.7 --with-coverage --cover-package=acmd --cover-min-percentage=80 --cover-html --cover-html-dir=build/test_reports

test3:
	nosetests-3.4

test: test3 test2

## Acceptance Test
centos7-%:
	docker build -f acceptance-test/Dockerfile.$@ -t acmd-$@ . > /tmp/docker_build
	docker run acmd-$@

ubuntu17-%:
	docker build -f acceptance-test/Dockerfile.$@ -t acmd-$@ . > /tmp/docker_build
	docker run acmd-$@

# Acceptance tests local code to verify release
acceptance-test: centos7-py2-local centos7-py3-local ubuntu17-py2-local ubuntu17-py3-local
	@echo "Acceptance Test Successful"

# Verification test runs released code to verify release
verification-test: centos7-py2-pip centos7-py2-shell centos7-py2-ushell ubuntu17-py2-pip
	@echo "Verification Test Successful"
##

.PHONY: all clean dist test_release release lint test2 test3 test acceptance-test


