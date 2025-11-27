// Entry point
%%raw(`import "./tailwind.css"`)
%%raw(`import "react-datepicker/dist/react-datepicker.css"`)

open ReactDOM.Client

let rootElement = ReactDOM.querySelector("#root")

switch rootElement {
| Some(domNode) =>
  let root = createRoot(domNode)
  Root.render(root, <App />)
| None => Js.log("No root element found")
}
