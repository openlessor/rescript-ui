type renderResult = {executorConfig: Premise.Config.t, html: string}

let render = (url: string): Js.Promise.t<renderResult> => {
  let appUrl = RescriptReactRouter.dangerouslyGetInitialUrl(~serverUrlString=url, ())
  // XXX: Hardcoded premiseId
  let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
  Premise.Config.fetch(premiseId)->Promise.then(config =>
    Js.Promise.resolve({
      html: ReactDOMServer.renderToString(
        <App initialExecutorConfig={config} serverUrl={appUrl} />,
      ),
      executorConfig: config,
    })
  )
}
