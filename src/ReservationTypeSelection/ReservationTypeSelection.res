let str = React.string

module State = {
  type t =
    | Hourly
    | Daily
  let defaultState: t = Hourly
  let (state, set) = signal(defaultState)
}

@react.component
let make = leaf(() => {
  <div className="my-auto">
    <label htmlFor="type_hourly">
      <input
        className="m-1"
        id="type_hourly"
        name="type"
        type_="radio"
        value="hour"
        onChange={_ => State.set(State.Hourly)}
        defaultChecked={State.state.value == State.Hourly}
      />
      <span className="p-1 pl-0"> {" Per Hour"->str} </span>
    </label>
    <label htmlFor="type_daily">
      <input
        className="m-1"
        id="type_daily"
        name="type"
        type_="radio"
        value="date"
        onChange={_ => State.set(State.Daily)}
        defaultChecked={State.state.value == State.Daily}
      />
      <span className="p-1 pl-0"> {" Per Day"->str} </span>
    </label>
  </div>
})
