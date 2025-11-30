type t =
  | Hourly
  | Daily
let defaultState: t = Hourly
let (state, set) = signal(defaultState)
