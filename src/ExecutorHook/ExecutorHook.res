module ExecutorConfig = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"
  /**
❯ curl http://localhost:54432/config/0e36f6ba-ac5d-423e-a3bb-bb939e1cb326
{"inventory":[{"id":1,"name":"test inventory","description":"testing","quantity":0,"tenantid":"0e36f6ba-ac5d-423e-a3bb-bb939e1cb326"}],"tenant":{"id":"0e36f6ba-ac5d-423e-a3bb-bb939e1cb326","name":"Example Tenant","description":"An example tenant"}}%
**/
  let base_url: string = "http://localhost:8899"
  let fetch = async (tenantId: string) => {
    open Fetch
    let response = await fetch(`${base_url}/config/${tenantId}`, {method: #GET})
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
// XXX: For now we hardcode the tenant ID
let tenantId = "0e36f6ba-ac5d-423e-a3bb-bb939e1cb326"
let executorConfig = tilia({
  "config": source(initialExecutorConfig, async (_prev, set) => {
    let config = await ExecutorConfig.fetch(tenantId)
    set(config)
  }),
})

let useExecutor = (): ExecutorConfig.t => {
  executorConfig["config"]
}
