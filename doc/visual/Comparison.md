| Feature/Api                            | Spectron | Puppeteer |
|----------------------------------------|----------|-----------|
| Element api                            | 2        | 1         |
| Page api                               | 1        | 2         |
| Browser api                            | 1        | 2         |
| Touchscreen/mouse/keyboard api         | 1        | 2         |
| Workers api                            | 0        | 2         |
| Request/Response api                   | 0        | 2         |
| Dialog api                             | 0        | 1         |
| Electron api                           | 2        | 0         |
| Device emulation                       | 1        | 2         |
| Page navigation                        | 1        | 1         |
| Function exposing                      | 0        | 1         |
| Commands chaining                      | 1        | 0         |
| Screenshots creation                   | 1        | 1         |
| Screen recording                       | 0        | 0         |
| Drag and drop                          | 2        | 1         |
| Access to raw Chrome Devtools Protocol | 1        | 1         |
| Headless testing                       | 0        | 1         |

>Note:
> 0 - missing
> 1 - basic api or feature exists
> 2 - extended api

Summary:

- Both have similar api related to interaction with page and element.
  If some method is missing, desired result can be achieved via other methods.

- Puppeteer methods return promise. No chaining support.
- Puppeteer has more browser and page related api.
- Puppeteer has convenient mouse/keyboard/touchscreen/dialog api.
- Puppeteer supports only testing in Chrome.
- Puppeteer has workers api
- Puppeteer supports headless mode

- Spectron has more usefull methods/shortcuts related to element interaction.
- Spectron methods return thenable object, supports command chaining.
- Spectron has shortcut for element drag-and-drop
- Spectron has debug feature( allows to pause browser execution and just into devtools )
- Spectron has full access to electron api( requires nodeIntegration to be enabled in electron )
- Spectron does not supports headless mode out of the box