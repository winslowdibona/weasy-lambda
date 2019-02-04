# weasy-lambda
Build weasyprint for python 3.6 to run on aws lambda.

## Building the package

1. Fork this repo
2. `git clone git@github.com:<your-name>/weasy-lambda.git`
3. `cd weasy-lambda`
4. `./build.sh`
5. `cp -r libs/. task/`

Now you can use the contents of this folder in your lambda package.

To test you can do

```
cp samples/handler.py task/
zip -r lambda.zip task/.
```
And upload the generated package to lambda. Make sure to set the execution timeout to at least 5 seconds as it can sometimes take weasyprint a little time to load. If you get an error saying the task timed out just bump the execution timeout setting.

## To Do
1. Create new build script that allows you to package the generated folder as a zip to use as a layer for aws lambda. 
