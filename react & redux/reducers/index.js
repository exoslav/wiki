import { combineReducers } from 'redux'
import listReducer from './reducer_list'
import controlsReducer from './reducer_controls'

const rootReducer = combineReducers({
  controls: controlsReducer,
  list: listReducer
})

export default rootReducer
