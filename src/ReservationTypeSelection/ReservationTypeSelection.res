let str = React.string

@react.component
let make = () => {
  <div className="my-auto">
    <label htmlFor="type_hour">
      <input className="m-1" id="type_hour" name="type" type_="radio" value="hour" />
      <span className="p-1 pl-0"> {" Hourly"->str} </span>
    </label>
    <label htmlFor="type_date">
      <input className="m-1" id="type_date" name="type" type_="radio" value="date" />
      <span className="p-1 pl-0"> {" Until specified date"->str} </span>
    </label>
  </div>
}
