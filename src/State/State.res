module Unit = {
  type t = [#second | #minute | #hour | #day | #week | #month | #year]
  // XXX: This default state should come from the server
  let defaultState: t = #hour
  let (signal, set) = signal(defaultState)
}

let main_store = tilia({
  "config": Premise.state,
  "unit": Unit.signal->lift,
})

// Crappy workaround because I can't figure out how to derive the state
let period_list = PeriodList.computeState(main_store["config"])
