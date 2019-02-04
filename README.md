# weasy-lambda
Build weasyprint for python 3.6 to run on aws lambda.

## Testing
1. `make build-package`
2. `cp samples/handler.py /build/package/task`
3. `make zip-package`
4. Upload the resulting package `weasy-lambda/build/package/task.zip` to lambda
5. Configure function to use `handler.handler` as the lambda handler
6. Set execution timeout to 10

## Build as lambda package
1. `make build-package`
2. Add your custom lambda handler to `weasy-lambda/build/package/task` or use the sample in `weasy-lambda/samples/handler.py`
3. `make zip-package`
4. Upload the resulting package `weasy-lambda/build/package/task.zip` to lambda

## Build as lambda layer
1. `make build-layer`
2. `make zip-layer`
3. Use the resulting package `weasy-lambda/build/layer/python.zip` to create a new lambda layer
