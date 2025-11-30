let str = React.string

module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = Pervasives.compare
})

@react.component
let make = leaf((~openDate, ~closeDate, ~activeId: option<string>) => {
  let config: Premise.Config.t = Premise.state["config"]
  let items = config.inventory
  let filterType = "all"
  let now = Js.Date.make()
  let today = Js.Date.fromFloat(Js.Date.setHoursMSMs(now, ~hours=0.0, ~minutes=0.0, ~seconds=0.0, ~milliseconds=0.0, ()))


  let heading = {
    if Js.Date.getTime(openDate) != Js.Date.getTime(closeDate) {
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
            active={activeId == Some(Belt.Int.toString(item.id))}
          />,
        items,
      )->React.array}
    </Card>
  </Card>
})
