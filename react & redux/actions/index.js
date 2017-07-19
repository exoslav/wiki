export const editGame = (index, key, value) => ({type: 'EDIT_GAME', index, key, value})
export const addGame = game => ({type: 'ADD_GAME', game})
export const playGame = () => ({type: 'PLAY'})
export const pauseGame = () => ({type: 'PAUSE'})
