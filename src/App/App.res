let getActiveId = (url: RescriptReactRouter.url) => {
  switch url.path {
  | list{"item", id, ..._} => Some(id)
  | _ => None
  }
}

@react.component
let make = (~serverUrl: RescriptReactRouter.url=?) => {
  let initialUrl = RescriptReactRouter.useUrl(~serverUrl?, ())
  let (url, setUrl) = React.useState(() => initialUrl)
  let (activeId, setActiveId) = React.useState(() => getActiveId(url))
  React.useEffect0(() => {
    let watcherID = RescriptReactRouter.watchUrl(newUrl => {
      Js.log2("URL changed to:", newUrl.path)
      setUrl(_ => newUrl)
      setActiveId(_ => getActiveId(newUrl))
    })

    // Cleanup function to unsubscribe when the component unmounts
    Some(() => RescriptReactRouter.unwatchUrl(watcherID))
  })

  switch url.path {
  | list{"item", ..._} | list{} => <Landing activeId={activeId} />
  | _ => <ErrorView />
  }
}
