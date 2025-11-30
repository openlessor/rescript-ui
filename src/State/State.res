module Period = {
  type t =
    | Hourly
    | Daily
  let defaultState: t = Hourly
  let (signal, set) = signal(defaultState)
}

let main_store = tilia({
  "config": Premise.state,
  "period": Period.signal->lift,
})
