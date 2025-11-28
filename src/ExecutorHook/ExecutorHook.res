module InventoryItem = {
  type t = {
    id: int,
    description: string,
    image: string,
    title: string,
    quantity: int,
  }

  @scope("JSON") @val
  external _parseJSON: string => t = "parse"
}

module ExecutorConfig = {
  type t = {inventory: array<InventoryItem.t>}

  @scope("JSON") @val
  external parseJSON: string => t = "parse"
}

type state = ErrorLoadingEndpoint | LoadingEndpoint | LoadedEndpoint(ExecutorConfig.t)

let endpoint_url: string = "https://62210a40afd560ea69a5c07b.mockapi.io/mock"

let fetchExecutorConfig = async () => {
  open Fetch
  let response = await fetch(endpoint_url, {method: #GET})
  ExecutorConfig.parseJSON(await response->Response.text)
}
let empty: ExecutorConfig.t = {inventory: []}
let executorConfig = tilia({
  "config": source(empty, async (_prev, set) => {
    let config = await fetchExecutorConfig()
    set(config)
  }),
})

let useExecutor = (): ExecutorConfig.t => {
  executorConfig["config"]
}
