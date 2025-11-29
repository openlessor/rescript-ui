module ExecutorConfig: {
  type t = {inventory: array<InventoryItem.t>}
  let fetch: unit => promise<t>
}

module SSR: {
  let empty: ExecutorConfig.t
  let context: React.Context.t<ExecutorConfig.t>
  module Provider: {
    type props<'value, 'children> = {
      value: 'value,
      children: 'children,
    }
    let make: React.componentLike<props<ExecutorConfig.t, React.element>, React.element>
  }
}

//type state =
//  | ErrorLoadingEndpoint
//  | LoadingEndpoint
//  | LoadedEndpoint(ExecutorConfig.t)
let useExecutor: unit => ExecutorConfig.t
