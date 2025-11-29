module ExecutorConfig = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"

  let endpoint_url: string = "https://62210a40afd560ea69a5c07b.mockapi.io/mock"
  let fetch = async () => {
    open Fetch
    let response = await fetch(endpoint_url, {method: #GET})
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
let executorConfig = tilia({
  "config": source(initialExecutorConfig, async (_prev, set) => {
    let config = await ExecutorConfig.fetch()
    set(config)
  }),
})

let useExecutor = (): ExecutorConfig.t => {
  executorConfig["config"]
}
