let { app, BrowserWindow } = require( 'electron' );

let mainWindow;

app.on( 'window-all-closed', () =>
{
  if( process.platform !== 'darwin' )
  app.quit();
});

app.on( 'ready', () =>
{
  mainWindow = new BrowserWindow
  ({
    width : 800,
    height : 600,
    show : false,
    frame : false,
    webPreferences :
    {
      nodeIntegration : true,
      enableRemoteModule : true // fixes https://github.com/electron-userland/spectron/issues/720
    },
  })

  mainWindow.loadFile( './index.html' );
  mainWindow.on( 'closed', () =>
  {
    mainWindow = null;
  });
});

