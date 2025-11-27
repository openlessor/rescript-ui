module InventoryItem: {
  type t = {
    id: int,
    description: string,
    image: string,
    title: string,
    quantity: int,
  }
}

module ExecutorConfig: {
  type t = {inventory: array<InventoryItem.t>}
}

type state =
  | ErrorLoadingEndpoint
  | LoadingEndpoint
  | LoadedEndpoint(ExecutorConfig.t)

let useExecutor: unit => ExecutorConfig.t
