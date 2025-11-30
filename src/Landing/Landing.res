let str = React.string

let addToCart = (state: Cart.t, id) => {
  {...state, cart: Belt.Array.concat(state.cart, [id])}
}

let removeFromCart = (state: Cart.t, id) => {
  {
    ...state,
    cart: Js.Array.filter(compareId => {
      compareId != id
    }, state.cart),
  }
}

@react.component
let make = (~dateA=?, ~dateB=?, ~activeId: option<string>) => {
  let now = Js.Date.make()
  let today = Js.Date.fromFloat(
    Js.Date.setHoursMSMs(now, ~hours=0.0, ~minutes=0.0, ~seconds=0.0, ~milliseconds=0.0, ()),
  )

  let (openDate, setOpenDate) = React.useState(() =>
    switch dateA {
    | Some(date) => Js.Date.fromString(date)
    | None => today
    }
  )
  let (closeDate, setCloseDate) = React.useState(() =>
    switch dateB {
    | Some(date) => Js.Date.fromString(date)
    | None => openDate
    }
  )
  let updateDate = openDate => {
    setOpenDate(openDate)
    setCloseDate(openDate)
  }

  let (state, dispatch) = React.useReducer((state, action) => {
    Js.Console.log("calling reducer")
    Js.Console.log({"state": state, "action": action})
    let result = switch action {
    | Cart.DispatchContext.AddToCart({id}) => addToCart(state, id)
    | Cart.DispatchContext.RemoveFromCart({id}) => removeFromCart(state, id)
    }
    Js.Console.log({"nextState": result})
    result
  }, {items: [], selected_item: None, cart: []})
  let cartCount = Belt.Array.length(state.cart)

  <Container>
    <Card className="bg-slate-200/40 border-slate-200/40 border-1 text-center">
      <h1 className="text-xl">
        <span>
          <Icon.MonitorCloud size={32} className="mr-2 my-auto inline content-start" />{"Cloud Hardware Rental"->str}
        </span>
      </h1>
    </Card>
    <Card className="grid grid-cols-[auto_1fr] auto-cols-auto bg-white/20">
      <span className="m-2 align-middle text-lg">
        <Icon.Calendar size={32} className="mr-2 my-auto inline content-start" />{"Select your reservation start date: "->str}
      </span>
      <div className="my-auto">
        <DatePicker
          minDate={today}
          onChange={updateDate}
          isOpen={false}
          className="m-2 block align-middle content-center"
          calendarClassName="bg-white"
          selected={openDate}
        />
      </div>
    </Card>
    <Card className="grid grid-cols-[auto_1fr] auto-cols-auto bg-white/20">
      <span className="m-2 align-middle text-lg">{"Select your reservation type: "->str}</span>
      <ReservationTypeSelection />
    </Card>
    <Cart.StateContext.Provider value={state}>
      <Cart.DispatchContext.Provider value={dispatch}>
        <InventoryList activeId={activeId} openDate={openDate} closeDate={closeDate} />
        <Cart count={cartCount} />
      </Cart.DispatchContext.Provider>
    </Cart.StateContext.Provider>
    <div className="w-full">
      <button
        className="mx-auto mt-4 bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded-sm">
        {"Book Reservation"->str}
      </button>
    </div>
  </Container>
}
