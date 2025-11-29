module ExecutorConfig = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"
}

let endpoint_url: string = "https://62210a40afd560ea69a5c07b.mockapi.io/mock"

let fetchExecutorConfig = async () => {
  open Fetch
  let response = await fetch(endpoint_url, {method: #GET})
  ExecutorConfig.parseJSON(await response->Response.text)
}

let initialExecutorConfig = %raw(
  "(typeof window !== 'undefined' ? window.__EXECUTOR_CONFIG__ ?? null : null)"
)
let executorConfig = tilia({
  "config": source(initialExecutorConfig, async (_prev, set) => {
    let config = await fetchExecutorConfig()
    set(config)
  }),
})

//type state = ErrorLoadingEndpoint | LoadingEndpoint | LoadedEndpoint(ExecutorConfig.t)

let useExecutor = (): ExecutorConfig.t => {
  executorConfig["config"]
}
