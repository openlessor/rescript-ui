module Unit = {
  type t =
    | Hour
    | Day
  let defaultState: t = Hour
  let (signal, set) = signal(defaultState)
}

let main_store = tilia({
  "config": Premise.state,
  "unit": Unit.signal->lift,
})
