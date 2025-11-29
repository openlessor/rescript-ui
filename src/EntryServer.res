open ExecutorHook
type renderResult = {executorConfig: ExecutorConfig.t, html: string}

let render = (url: string): Js.Promise.t<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  ExecutorHook.fetchExecutorConfig()->Promise.then(config =>
    Js.Promise.resolve({
      html: ReactDOMServer.renderToString(<App serverUrl={appUrl} />),
      executorConfig: config,
    })
  )
}
