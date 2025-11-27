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

let endpoint_url: string = "https://62210a40afd560ea69a5c07b.mockapi.io/mock"

let executorConfigAtom = Jotai.Atom.makeAsync(async () => {
  open Fetch
  let response = await fetch(endpoint_url, {method: #GET})
  (ExecutorConfig.parseJSON(await response->Response.text), undefined)
})

type state = ErrorLoadingEndpoint | LoadingEndpoint | LoadedEndpoint(ExecutorConfig.t)

let useExecutor = (): ExecutorConfig.t => {
  let (executorConfig, _) = Jotai.Atom.useAtomValueAsync(executorConfigAtom)
  executorConfig
}
