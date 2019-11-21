## How to fill input fields of a form and click submit button.

Please check out [first tutorial](FirstPuppeteerTest.md) if you don't have test suite prepared.

## Create Html page

Create `index.html` file and paste there following code: 

```html
<html>
<head>
	<title>Form examples</title>
</head>
<body>
	<form name="testForm" method="post" onsubmit="return validate()">
		Value:<input type="text" id="input1" name="input1" >
		<input type="submit" value="Submit" id="submit">
		Result:<p id="result"></p>
  </form>
  <script>
    function validate()
    {
      var result =document.getElementById("result");
      result.innerText = document.forms["testForm"]["input1"].value ;
      return false;
    }
  </script>
</body>
</html>
```

## Write a test routine

Add following test routine to your suite:

```javascript
async function submitForm( test )
{
  let self = this;
  
  // Prepare path to electron app script( main.js )
  let indexHtml = _.path.nativize( _.path.join( __dirname, 'asset/form/index.html' ) );

  // Create app instance using path to main.js and electron binary
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtml ]//use path to index html as arg for electron app
  })

  // Start the electron app
  await app.start()
  // Waint until page will be loaded
  await app.client.waitUntilTextExists( 'p', 'Result', 5000 );
  
  // Set input field value
  await app.client.$( '#input1' ).setValue( '321' );
  
  //Click submit button
  await app.client.$( '#submit' ).click();
  
  // Check text result
  var result = await app.client.$( '#result' ).getText();
  test.identical( result, 'Result:321' )

  //Stop the electron app
  return app.stop();
}
```

## Register and run test routine

Add test routine to `tests` map and the end of test suite file.

To run test routine enter:
```
node Puppeteer.test.ss r:submitForm v:5
```

[Full sample](../../../sample/puppeteer/SubmitForm.test.s)

[Back to content](../README.md#Tutorials)





