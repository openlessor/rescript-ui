open ExecutorHook
type renderResult = {executorConfig: ExecutorConfig.t, html: string}

let render = (url: string): Js.Promise.t<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  ExecutorConfig.fetch()->Promise.then(config =>
    Js.Promise.resolve({
      html: ReactDOMServer.renderToString(
        <App initialExecutorConfig={config} serverUrl={appUrl} />,
      ),
      executorConfig: config,
    })
  )
}
