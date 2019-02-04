
build-package:
	mkdir -p build/package/task
	cp build_scripts/weasy_package.sh build/package/task
	docker run -it -v $(PWD)/build/package/task:/var/task \
	    -e LD_LIBRARY_PATH='/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/var/task/lib64' \
	    lambdalinux/baseimage-amzn /var/task/weasy_package.sh
	cp -r libs/* build/package/task/lib

build-layer:
	mkdir -p build/layer/python
	cp build_scripts/weasy_layer.sh build/layer/python
	docker run -it -v $(PWD)/build/layer/python:/opt/python \
    -e LD_LIBRARY_PATH='/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/opt/python:/opt/python/lib:/opt/python/lib64' \
    lambdalinux/baseimage-amzn /opt/python/weasy_layer.sh
	cp -r libs/* build/layer/python/lib

zip-package:
	zip -r build/package/task.zip build/package/task/.

zap-layer:
	zip -r build/layer/python.zip build/layer/python/.
