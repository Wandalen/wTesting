
const _ = require( 'wTesting' );

//

function programLogger( test )
{
  const a = test.assetFor( false );
  const program = a.program( testApp );

  const startWithProgramLogger = a.process.starter
  ({
    ... program.start.predefined,
    ready : a.ready,
  });

  /* - */

  startWithProgramLogger( `node ${ program.filePath }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'inside testApp' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function testApp()
  {
    console.log( 'inside testApp' );
  }
}

//

function troLogger( test )
{
  const a = test.assetFor( false );
  const program = a.program( testApp );

  const loggerToTro = new _.Logger({ output : test.logger, verbosity : 7 });
  const startWithTroLogger = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 1,
    ready : a.ready,
    mode : 'shell',
    logger : loggerToTro,
  });

  /* - */

  startWithTroLogger( `node ${ program.filePath }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'inside testApp' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function testApp()
  {
    console.log( 'inside testApp' );
  }
}

//

function consoleLogger( test )
{
  const a = test.assetFor( false );
  const program = a.program( testApp );

  const loggerToConsole = new _.Logger({ output : console });
  const startWithConsoleLogger = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 1,
    ready : a.ready,
    mode : 'shell',
    logger : loggerToConsole,
  });

  /* - */

  startWithConsoleLogger( `node ${ program.filePath }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), 'inside testApp' );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function testApp()
  {
    console.log( 'inside testApp' );
  }
}

//

var Self =
{
  name : 'TestLogger',
  tests :
  {
    programLogger,
    troLogger,
    consoleLogger,
  },
};

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
