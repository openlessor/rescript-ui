open ExecutorHook
type renderResult = {executorConfig: ExecutorConfig.t, html: string}

let render = (url: string): Js.Promise.t<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  // XXX: Hardcoded tenantId
  let tenantId = "0e36f6ba-ac5d-423e-a3bb-bb939e1cb326"
  ExecutorConfig.fetch(tenantId)->Promise.then(config =>
    Js.Promise.resolve({
      html: ReactDOMServer.renderToString(
        <App initialExecutorConfig={config} serverUrl={appUrl} />,
      ),
      executorConfig: config,
    })
  )
}
