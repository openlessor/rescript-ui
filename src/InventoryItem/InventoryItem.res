let str = React.string

type t = {
  id: int,
  description: string,
  image: string,
  title: string,
  quantity: int,
}

@scope("JSON") @val
external _parseJSON: string => t = "parse"

@react.component
let make = (~item: t, ~active=?) => {
  let {id, title, description} = item
  let image = "https://placeholdr.ai/1ca27004-f6f9-413a-8dbf-6c088feabead/256/256"
  //let _dispatch = React.useContext(Cart.DispatchContext.context)
  //let cartState = React.useContext(Cart.StateContext.context)
  //let {path} = RescriptReactRouter.useUrl()
  let matches = [] // Js.Array.filter(cart_item => cart_item == item.id, cartState.cart)
  let matchCount = Js.Array.length(matches)
  let quantity = matchCount > 0 ? Belt.Int.toString(Js.Array.length(matches)) : "0"
  let available = Belt.Int.toString(item.quantity - matchCount)
  <a
    id={"item-" ++ Belt.Int.toString(id)}
    onClick={e => {
      e->JsxEvent.toSyntheticEvent->JsxEvent.Synthetic.preventDefault
      RescriptReactRouter.replace("/item/" ++ Belt.Int.toString(id))
    }}
    href={"/item/" ++ Belt.Int.toString(id)}
    className="block">
    <button className="relative m-[1.5] flex flex-col">
      <div className="rounded-sm border-2 shadow-sm m-0 p-0">
        <img className="p-[1.5] w-40 h-40" src={image} style={Obj.magic({"width": "100%"})} />
      </div>
      <div className="flex flex-row justify-between w-full bg-gray-300 text-white shadow-sm">
        <span className="drop-shadow-sm">
          <i className="light-icon-shopping-cart text-xl" />
          <span className="text-[0.5rem]" title="Quantity in cart"> {quantity->str} </span>
        </span>
        <span className="drop-shadow-sm">
          <i className="light-icon-checks text-xl" />
          <span className="text-[0.5rem]" title="Quantity available"> {available->str} </span>
        </span>
      </div>
      <div
        className="flex flex-col text-align-center w-full bg-white text-gray-300 rounded-sm m-[1.5] justify-self-end">
        <h2 className="text-xs drop-shadow-sm text-gray-500"> {title->str} </h2>
        <p className={(active == Some(true) ? "" : "hidden ") ++ "text-xs m-2"}>
          {description->str}
        </p>
      </div>
    </button>
  </a>
}
