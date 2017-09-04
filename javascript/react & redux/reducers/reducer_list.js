const initialState = [
  {
    name: null,
    text: ''
  }
]

const listReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD':
      return state.concat({
        name: action.name,
        text: action.text
      })
      break
    case 'EDIT':
      return state.map((listItem, index) => {
        if(index === action.index) {
          return Object.assign({}, listItem, {
            [action.key]: action.value
          })
        }
        return game
      })
      break
    default:
      return state
  }
}

export default listReducer
