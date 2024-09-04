.PHONY: clean virtualenv test docker dist dist-upload

clean:
	find . -name '*.py[co]' -delete

setup:
	python3 -m venv --prompt "|> $$virt_name  >" env
	env/bin/pip install --upgrade pip
	env/bin/pip install -e .
	env/bin/pip install -r requirements-dev.txt
	@echo
	@echo "VirtualENV Setup Complete. Now run: source env/bin/activate"
	@echo


style:
	git ls-files --cached --modified --exclude-standard |egrep \.py$$ |xargs pycodestyle --config .pycodestyle

autopep:
	git ls-files --cached --modified --exclude-standard |egrep \.py$$ |xargs autopep8 -i

test:
	python -m pytest \
	        -v \
	        tests/

dist: clean
	rm -rf dist/*
	python setup.py sdist
	python setup.py bdist_wheel

publish:
	rm -rf dist/*
	python -m build
	twine upload -r testpypi dist/*
