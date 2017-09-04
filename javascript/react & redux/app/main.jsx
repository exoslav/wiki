import { createStore } from 'redux'
import * as actions from '../actions'
import rootReducer from '../reducers/index.js'

const store = createStore(rootReducer)

store.subscribe(() => {
  console.log(' --- store changed --- ')
  console.log('store changed', store.getState().games)
  console.log('store changed', store.getState().controls.isPlaying)
  console.log('');
  console.log('');
})

store.dispatch(actions.editGame(0, 'name', 'Nova hra'))
store.dispatch(actions.editGame(0, 'name', 'Dalsi hra'))
store.dispatch(actions.addGame({'testGame': 'testGame'}))

store.dispatch(actions.playGame())
store.dispatch(actions.pauseGame())
