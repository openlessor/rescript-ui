%%raw(`require("react-datepicker/dist/react-datepicker.css")`)

@react.component @module("react-datepicker")
external make: (
  ~calendarClassName: string,
  ~className: string,
  ~isOpen: bool,
  ~minDate: Date.t,
  ~onChange: 'a,
  ~selected: Date.t,
) => React.element = "default"
