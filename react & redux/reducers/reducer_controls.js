const initialState = {
  isPlaying: false
}

const controlsReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'PLAY':
      return Object.assign({}, state, {
        isPlaying: true
      })
      break;
    case 'PAUSE':
      return Object.assign({}, state, {
        isPlaying: false
      })
      break;
    default:
      return state
  }
}

export default controlsReducer
