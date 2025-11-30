open State
let str = React.string

module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = Pervasives.compare
})

@react.component
let make = leaf((
  ~openDate: option<Js.Date.t>=?,
  ~closeDate: option<Js.Date.t>=?,
  ~activeId: option<string>,
) => {
  let config: Premise.Config.t = main_store["config"]
  let unit = main_store["unit"]
  let items = config.inventory
  let filterType = "all"
  let now = Js.Date.make()
  let today = Js.Date.fromFloat(
    Js.Date.setHoursMSMs(now, ~hours=0.0, ~minutes=0.0, ~seconds=0.0, ~milliseconds=0.0, ()),
  )
  let openDate = switch openDate {
  | Some(date) => date
  | _ => today
  }
  let closeDate = switch closeDate {
  | Some(date) => date
  | _ => today
  }
  React.useEffect(() => {
    Js.Console.log("Open Date:")
    Js.Console.log(openDate)
    Js.Console.log("Close Date:")
    Js.Console.log(closeDate)
    Some(() => ())
  }, [openDate, closeDate])
  let heading = {
    if unit != Unit.Hour && openDate != closeDate {
      // The open date and close date are at least 1 day apart
      "Showing " ++
      filterType ++
      " equipment available from " ++
      Js.Date.toLocaleDateString(openDate) ++
      " to " ++
      Js.Date.toLocaleDateString(closeDate)
    } else {
      "Showing " ++
      filterType ++
      " equipment available " ++
      switch Js.Date.getTime(openDate) == Js.Date.getTime(today) {
      | true => "today"
      | false => Js.Date.toLocaleDateString(openDate)
      }
    }
  }

  <Card className="m-0 p-0 bg-white/30 border-2 border-b-4 border-r-4 border-gray-200/60">
    <h1 className="block align-middle text-lg content-center">
      <Icon.SearchIcon className="inline" />
      <span className="align-middle"> {heading->str} </span>
    </h1>
    <Card
      className="border-none shadow-none shadow-transparent m-0 p-0 place-content-start grid lg:grid-cols-8 grid-cols-4 gap-4">
      {Js.Array.map(
        (item: InventoryItem.t) =>
          <InventoryItem
            key={Belt.Int.toString(item.id)}
            item={item}
            _active={activeId == Some(Belt.Int.toString(item.id))}
          />,
        items,
      )->React.array}
    </Card>
  </Card>
})
