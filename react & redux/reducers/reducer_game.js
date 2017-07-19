const initialState = [
  {
    name: null,
    rows: null,
    cells: null,
    initialBoard: null,
    finalBoard: null,
    timer: null,
    isValid: false,
    shouldPause: false,
    isPlaying: false,
    livingCells: [],
    Board: null,
    GraphChart: null
  }
]

const gameReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD_GAME':
      return state.concat(action.game)
      break
    case 'EDIT_GAME':
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

export default gameReducer
