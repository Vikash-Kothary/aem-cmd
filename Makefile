all: dist

clean:
	rm -rf dist build aem_cmd.egg-info test_reports .coverage
	rm -f *.log
	find . | grep \.pyc$ | xargs rm

dist: clean
	python setup.py bdist_wheel

test_release: dist
	twine upload -r pypitest dist/*

release: dist
	twine upload -r pypi dist/*

test:
	nosetests --with-coverage --cover-package=acmd --cover-min-percentage=80 --cover-html --cover-html-dir=build/test_reports

.PHONY: all clean dist test
