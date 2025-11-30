module ExecutorConfig = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"

  // XXX @todo Make this base URL configurable from an env var
  // window.location.origin is not SSR friendly
  let base_url: string = "http://localhost:5173/api"
  let fetch = async (premiseId: string) => {
    open Fetch
    let response = await fetch(`${base_url}/config/${premiseId}`, {method: #GET})
    parseJSON(await response->Response.text)
  }
}

module SSR = {
  let empty: ExecutorConfig.t = {inventory: []}
  let context: React.Context.t<ExecutorConfig.t> = React.createContext(empty)

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value: ExecutorConfig.t, ~children: React.element) => {
      let element: React.element = React.createElement(provider, {value, children})
      element
    }
  }
}

let domExecutorConfig: Js.Nullable.t<ExecutorConfig.t> = %raw(
  "(typeof window !== 'undefined' ? window.__EXECUTOR_CONFIG__ ?? null : null)"
)
//let ctx = React.useContext(SSR.context)
let initialExecutorConfig = switch Js.Nullable.toOption(domExecutorConfig) {
| Some(config) => config
| None => SSR.empty
}
// XXX: For now we hardcode the premise ID
let premiseId = "a55351b1-1b78-4b6c-bd13-6859dc9ad410"
let executorConfig = tilia({
  "config": source(initialExecutorConfig, async (_prev, set) => {
    let config = await ExecutorConfig.fetch(premiseId)
    set(config)
  }),
})

let useExecutor = (): ExecutorConfig.t => {
  executorConfig["config"]
}
