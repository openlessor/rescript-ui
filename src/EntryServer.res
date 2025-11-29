type renderResult = {html: string}

let render = (url: string): Js.Promise.t<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  let html = ReactDOMServer.renderToString(<App serverUrl={appUrl} />)

  Js.Promise.resolve({html: html})
}
