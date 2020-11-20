let { app, BrowserWindow } = require( 'electron' );

let mainWindow;

app.on( 'ready', () =>
{
  mainWindow = new BrowserWindow
  ({
    width : 800,
    height : 600,
    webPreferences :
    {
      nodeIntegration : true,
      enableRemoteModule : true
    },
  })

  mainWindow.loadFile( './index.html' );
  mainWindow.on( 'closed', () =>
  {
    mainWindow = null;
  });
});
