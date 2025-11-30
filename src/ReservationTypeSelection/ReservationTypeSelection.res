open State
let str = React.string

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
        onChange={e => {
          let inputEl = e->ReactEvent.Form.currentTarget
          if inputEl["checked"] == true {
            Period.set(Period.Hourly)
          }
        }}
        checked={main_store["period"] == Period.Hourly}
        autoComplete="off"
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
        onChange={e => {
          let inputEl = e->ReactEvent.Form.currentTarget
          if inputEl["checked"] == true {
            Period.set(Period.Daily)
          }
        }}
        checked={main_store["period"] == Period.Daily}
        autoComplete="off"
      />
      <span className="p-1 pl-0"> {" Per Day"->str} </span>
    </label>
  </div>
})
