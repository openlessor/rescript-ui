module ExecutorConfig: {
  type t = {inventory: array<InventoryItem.t>}
}

//type state =
//  | ErrorLoadingEndpoint
//  | LoadingEndpoint
//  | LoadedEndpoint(ExecutorConfig.t)
let fetchExecutorConfig: unit => promise<ExecutorConfig.t>
let useExecutor: unit => ExecutorConfig.t
