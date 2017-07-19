const initialState = [
  {
    name: null,
    text: ''
  }
]

const listReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD':
      return state.concat(action.game)
      break
    case 'DELETE':
      return state.map((game, index) => {
        if(index === action.index) {
          return Object.assign({}, game, {
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
