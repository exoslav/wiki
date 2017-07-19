import { combineReducers } from 'redux'
import gameReducer from './reducer_game'
import controlsReducer from './reducer_controls'

const rootReducer = combineReducers({
  controls: controlsReducer,
  games: gameReducer
})

export default rootReducer
